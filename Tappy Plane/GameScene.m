//
//  GameScene.m
//  Tappy Plane
//
//  Created by Gajaharan Satkunanandan on 02/05/2017.
//  Copyright (c) 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import "GameScene.h"
#import "TPlane.h"
#import "TScrollingLayer.h"
#import "TConstants.h"
#import "TObstacleLayer.h"
#import "TBitmapFontLabel.h"
#import "TTilesetTextureProvider.h"
#import "TButton.h"
#import "TGameOverMenu.h"
#import "TGetReadyMenu.h"


typedef enum : NSUInteger {
    GameReady,
    GameRunning,
    GameOver,
} GameState;

@interface GameScene ()

@property (nonatomic) TPlane *player;
@property (nonatomic) SKNode *world;
@property (nonatomic) TScrollingLayer *background;
@property (nonatomic) TScrollingLayer *foreground;
@property (nonatomic) TObstacleLayer *obstacles;
@property (nonatomic) TBitmapFontLabel *scoreLabel;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger bestScore;
@property (nonatomic) TGetReadyMenu *getReadyMenu;
@property (nonatomic) TGameOverMenu *gameOverMenu;
@property (nonatomic) GameState gameState;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self setupScene];

}

-(void)setupScene {
    
    // Set background colour to sky blue.
    self.backgroundColor = [SKColor colorWithRed:0.835294118 green:0.929411765 blue:0.968627451 alpha:1.0];
    
    // Get atlas file.
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    // Setup world.
    _world = [SKNode node];
    [self addChild:_world];
    
    // Setup background.
    NSMutableArray *backgroudTiles = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        [backgroudTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]]];
    }

    _background = [[TScrollingLayer alloc] initWithTiles:backgroudTiles];;
    _background.horizontalScrollSpeed = -60;
    _background.scrolling = YES;
    [_world addChild:_background];
    
    // Setup foreground.
    _foreground = [[TScrollingLayer alloc] initWithTiles:@[[self generateGroundTile],
                                                            [self generateGroundTile],
                                                            [self generateGroundTile]]];
    _foreground.horizontalScrollSpeed = -80;
    _foreground.scrolling = YES;
    [_world addChild:_foreground];
    
    // Setup obstacle layer.
    _obstacles = [[TObstacleLayer alloc] init];
    _obstacles.collectableDelegate = self;
    _obstacles.horizontalScrollSpeed = -80;
    _obstacles.scrolling = YES;
    _obstacles.floor = 0.0;
    _obstacles.ceiling = self.size.height;
    [_world addChild:_obstacles];
    
    // Setup player.
    _player = [[TPlane alloc] init];
    _player.physicsBody.affectedByGravity = NO;
    [_world addChild:_player];
    
    // Setup score label.
    _scoreLabel = [[TBitmapFontLabel alloc] initWithText:@"0" andFontName:@"number"];
    _scoreLabel.position = CGPointMake(self.size.width * 0.5, self.size.height - 100);
    [self addChild:_scoreLabel];
    
    
    //TButton * button = [TButton spriteNodeWithTexture:[graphics textureNamed:@"buttonPlay"]];
    //button.position = CGPointMake(self.size.width * 0.5, self.size.height *.05);
    //[button setPressedTarget:self withAction:@selector(pressedPlayButton)];
    //[self addChild:button];
    
    // Setup get ready menu.
    _getReadyMenu = [[TGetReadyMenu alloc] initWithSize:self.size andPlanePosition:CGPointMake(self.size.width * 0.3, self.size.height * 0.5)];
    [self addChild:_getReadyMenu];
    
    // Setup game over menu.
    _gameOverMenu = [[TGameOverMenu alloc] initWithSize:self.size];
    _gameOverMenu.delegate = self;
    
    
    // Load best score.
    self.bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_BEST_SCORE];
    
    // Setup physics.
    self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
    self.physicsWorld.contactDelegate = self;
    
    // Start a new game.
    [self newGame];
    
}

-(SKSpriteNode*)generateGroundTile
{
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"groundGrass"]];
    sprite.anchorPoint = CGPointZero;
    
    CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
    CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 403 - offsetX, 15 - offsetY);
    CGPathAddLineToPoint(path, NULL, 367 - offsetX, 35 - offsetY);
    CGPathAddLineToPoint(path, NULL, 329 - offsetX, 34 - offsetY);
    CGPathAddLineToPoint(path, NULL, 287 - offsetX, 7 - offsetY);
    CGPathAddLineToPoint(path, NULL, 235 - offsetX, 11 - offsetY);
    CGPathAddLineToPoint(path, NULL, 205 - offsetX, 28 - offsetY);
    CGPathAddLineToPoint(path, NULL, 168 - offsetX, 20 - offsetY);
    CGPathAddLineToPoint(path, NULL, 122 - offsetX, 33 - offsetY);
    CGPathAddLineToPoint(path, NULL, 76 - offsetX, 31 - offsetY);
    CGPathAddLineToPoint(path, NULL, 46 - offsetX, 11 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 16 - offsetY);
    
    sprite.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    sprite.physicsBody.categoryBitMask = CATEGORY_GROUND;
    
    //SKShapeNode *bodyShape = [SKShapeNode node];
    //bodyShape.path = path;
    ///bodyShape.strokeColor = [SKColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    //bodyShape.lineWidth = 1.0;
    //[sprite addChild:bodyShape];
    
    return sprite;
}

-(void)pressedStartNewGameButton {
    SKSpriteNode *blackRectangle = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:self.size];
    //blackRectangle.centerRect = CGRectMake(0,0,self.size.width, self.size.height);
    //blackRectangle.anchorPoint = CGPointMake(0, 0);
    //blackRectangle.position = CGPointMake(self.size.width *0.5,self.size.height *0.5);
    //blackRectangle.alpha = 0.0;
    [self addChild:blackRectangle];
    
    SKAction *startNewGame = [SKAction runBlock:^{
        [self newGame];
        [self.gameOverMenu removeFromParent];
        [self.getReadyMenu show];
    }];
    
    SKAction *fadeTransition = [SKAction sequence:@[[SKAction fadeInWithDuration:0.4],
                                                    startNewGame,
                                                    [SKAction fadeOutWithDuration:0.6],
                                                    [SKAction removeFromParent]]];
    [blackRectangle runAction:fadeTransition];

}


-(void)newGame {
    
    // Randomize tileset.
    [[TTilesetTextureProvider getProvider] randomizeTileset];
    
    // Reset layers.
    self.foreground.position = CGPointZero;
    for (SKSpriteNode *node in self.foreground.children) {
        node.texture = [[TTilesetTextureProvider getProvider] getTextureForKey:@"ground"];
    }
    [self.foreground layoutTiles];
    self.obstacles.position = CGPointZero;
    [self.obstacles reset];
    self.obstacles.scrolling = NO;
    self.background.position = CGPointMake(0, 0);
    [self.background layoutTiles];
    
    // Reset score.
    self.score = 0;
    self.scoreLabel.alpha = 1.0;
    
    
    // Reset plane.
    self.player.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.5);
    self.player.physicsBody.affectedByGravity = NO;
    [self.player reset];
    
    // Set game state to ready
    self.gameState = GameReady;

}

//-(void)pressedPlayButton {
//    NSLog(@"Play Button pressed");
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    //for (UITouch *touch in touches) {
        if (self.gameState == GameReady) {
            [self.getReadyMenu hide];
            self.player.physicsBody.affectedByGravity = YES;
            self.obstacles.scrolling = YES;
            self.gameState = GameRunning;
        }
        
        if (self.gameState == GameRunning) {
            self.player.accelerating = YES;
        }
    //}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.gameState == GameRunning) {
        self.player.accelerating = NO;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    static NSTimeInterval lastCallTime;
    NSTimeInterval timeElapsed = currentTime - lastCallTime;
    if (timeElapsed > minFPS) {
        timeElapsed = minFPS;
    }
    lastCallTime = currentTime;
    
    [self.player update];
    if (self.gameState == GameRunning && self.player.crashed) {
        // Player just crashed in last frame so trigger game over.
        [self bump];
        [self gameOver];
    }
    
    if (self.gameState != GameOver) {
        [self.background updateWithTimeElpased:timeElapsed];
        [self.foreground updateWithTimeElpased:timeElapsed];
        [self.obstacles updateWithTimeElpased:timeElapsed];
    }

    
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    if (contact.bodyA.categoryBitMask == CATEGORY_PLANE) {
        [self.player collide:contact.bodyB];
    }
    else if (contact.bodyB.categoryBitMask == CATEGORY_PLANE) {
        [self.player collide:contact.bodyA];
    }
    
}

-(void)wasCollected:(TCollectable *)collectable {
    self.score += collectable.pointValue;
}

-(void)setScore:(NSInteger)score {
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
}

-(void)gameOver
{
    // Update game state.
    self.gameState = GameOver;
    // Fade out score display.
    [self.scoreLabel runAction:[SKAction fadeOutWithDuration:0.4]];
    // Set properties on game over menu
    self.gameOverMenu.score = self.score;
    self.gameOverMenu.medal = [self getMedalForCurrentScore];
    // Updtate best score.
    if (self.score > self.bestScore) {
        self.bestScore = self.score;
        [[NSUserDefaults standardUserDefaults] setInteger:self.bestScore forKey:KEY_BEST_SCORE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.gameOverMenu.bestScore = self.bestScore;
    // Show game over menu.
    [self addChild:self.gameOverMenu];
    [self.gameOverMenu show];
}

-(MedalType)getMedalForCurrentScore
{
    NSInteger adjustedScore = self.score - (self.bestScore / 5);
    
    if (adjustedScore >= 45) {
        return MedalGold;
    } else if (adjustedScore >= 25) {
        return MedalSilver;
    } else if (adjustedScore >= 10) {
        return MedalBronze;
    }
    return MedalNone;
}

-(void)bump
{
    SKAction *bump = [SKAction sequence:@[[SKAction moveBy:CGVectorMake(-5, -4) duration:0.1],
                                          [SKAction moveTo:CGPointZero duration:0.1]]];
    [self.world runAction:bump];
}

@end
