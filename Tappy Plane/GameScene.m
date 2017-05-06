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

@interface GameScene ()

@property (nonatomic) TPlane *player;
@property (nonatomic) SKNode *world;
@property (nonatomic) TScrollingLayer *background;

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

    _background = [[TScrollingLayer alloc] initWithTiles:backgroudTiles];
    _background.horizontalScrollSpeed = -60;
    _background.scrolling = YES;
    [_world addChild:_background];
    
    // Setup player.
    _player = [[TPlane alloc] init];
    _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    _player.physicsBody.affectedByGravity = NO;
    [_world addChild:_player];
    _player.engineRunning = YES;
    
    // Setup physics.
    self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        self.player.engineRunning = !self.player.engineRunning;
        //[self.player setRandomColour];
        self.player.physicsBody.affectedByGravity = YES;
        self.player.accelerating = YES;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
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
    [self.background updateWithTimeElpased:timeElapsed];
    
}

@end
