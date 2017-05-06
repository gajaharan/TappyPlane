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

@interface GameScene ()

@property (nonatomic) TPlane *player;
@property (nonatomic) SKNode *world;
@property (nonatomic) TScrollingLayer *background;
@property (nonatomic) TScrollingLayer *foreground;
@property (nonatomic) TObstacleLayer *obstacles;


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
    //_obstacles.collectableDelegate = self;
    _obstacles.horizontalScrollSpeed = -80;
    _obstacles.scrolling = YES;
    _obstacles.floor = 0.0;
    _obstacles.ceiling = self.size.height;
    [_world addChild:_obstacles];
    
    // Setup player.
    _player = [[TPlane alloc] init];
    _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    _player.physicsBody.affectedByGravity = NO;
    [_world addChild:_player];
    
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

-(void)newGame {
    
    // Reset layers.
    self.foreground.position = CGPointZero;
    [self.foreground layoutTiles];
    self.obstacles.position = CGPointZero;
    [self.obstacles reset];
    self.obstacles.scrolling = NO;
    self.background.position = CGPointMake(0, 30);
    [self.background layoutTiles];
    
    
    // Reset plane.
    self.player.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.5);
    self.player.physicsBody.affectedByGravity = NO;
    [self.player reset];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        //self.player.engineRunning = !self.player.engineRunning;
        //[self.player setRandomColour];
        if(self.player.crashed) {
            //reset game
            [self newGame];
        } else {
        self.player.physicsBody.affectedByGravity = YES;
        self.player.accelerating = YES;
            self.obstacles.scrolling = YES;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.player.accelerating = NO;
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
    
    if(!self.player.crashed) {
    [self.background updateWithTimeElpased:timeElapsed];
    [self.foreground updateWithTimeElpased:timeElapsed];
        [self.obstacles updateWithTimeElpased:timeElapsed];
    }

    
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask == CATEGORY_PLANE) {
        [self.player collide:contact.bodyB];
    }
    else if (contact.bodyB.categoryBitMask == CATEGORY_PLANE) {
        [self.player collide:contact.bodyA];
    }
    
}

@end
