//
//  TPlane.m
//  Tappy Plane
//
//  Created by Gajaharan Satkunanandan on 02/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import "TPlane.h"

@interface TPlane()
@property (nonatomic) NSMutableArray *planeAnimations; // Holds animation actions.
@property (nonatomic) SKEmitterNode *puffTrailEmitter;
@property (nonatomic) CGFloat puffTrailBirthRate;
@property (nonatomic) SKAction *crashTintAction;

@end

@implementation TPlane

- (instancetype)init {
    self = [super init];
    self = [super initWithImageNamed:@"planeBlue1@2x"];
    if (self) {
        
        // Setup physics body with path.
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width * 0.5];
        self.physicsBody.mass = 0.08;
        
        // Init array to hold animation actions.
        _planeAnimations = [[NSMutableArray alloc] init];
        
        // Load animation plist file.
        NSString *animationPlistPath = [[NSBundle mainBundle] pathForResource:@"PlaneAnimations" ofType:@"plist"];
        NSDictionary *animations = [NSDictionary dictionaryWithContentsOfFile:animationPlistPath];
        for (NSString *key in animations) {
            [self.planeAnimations addObject:[self animationFromArray:[animations objectForKey:key] withDuration:0.4]];
        }
        
        // Setup puff trail particle effect.
        NSString *particleFile = [[NSBundle mainBundle] pathForResource:@"PlanePuffTrail" ofType:@"sks"];
        _puffTrailEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:particleFile];
        _puffTrailEmitter.position = CGPointMake(-self.size.width * 0.5, -5);
        [self addChild:self.puffTrailEmitter];
        self.puffTrailBirthRate = _puffTrailEmitter.particleBirthRate;
        self.puffTrailEmitter.particleBirthRate = 0;
        
        [self setRandomColour];
        
    }
    return self;
}

- (SKAction*)animationFromArray:(NSArray*)textureNames withDuration:(CGFloat)duration {
    // Create array to hold textures.
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    // Get planes atlas.
    SKTextureAtlas *planesAtlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    // Loop through textureNames array and load textures.
    for (NSString *textureName in textureNames) {
        [frames addObject:[planesAtlas textureNamed:textureName]];
    }
    // Calculate time per frame.
    CGFloat frameTime = duration / (CGFloat)frames.count;
    // Create and return animation action.
    return [SKAction repeatActionForever:[SKAction animateWithTextures:frames
                                                          timePerFrame:frameTime
                                                                resize:NO restore:NO]];
}

- (void)setRandomColour
{
    [self removeActionForKey:TPKEY_PlANE_ANIMATION];
    SKAction *animation = [self.planeAnimations objectAtIndex:arc4random_uniform((uint)self.planeAnimations.count)];
    [self runAction:animation withKey:TPKEY_PlANE_ANIMATION];
    if (!self.engineRunning) {
        [self actionForKey:TPKEY_PlANE_ANIMATION].speed = 0;
    }
    
}

- (void)setEngineRunning:(BOOL)engineRunning {
    _engineRunning = engineRunning && !self.crashed;
    if (engineRunning) {
        //[self.engineSound play];
        //[self.engineSound fadeIn:1.0];
        self.puffTrailEmitter.targetNode = self.parent;
        [self actionForKey:TPKEY_PlANE_ANIMATION].speed = 1;
        self.puffTrailEmitter.particleBirthRate = self.puffTrailBirthRate;
    }
    else {
        //[self.engineSound fadeOut:0.5];
        [self actionForKey:TPKEY_PlANE_ANIMATION].speed = 0;
        self.puffTrailEmitter.particleBirthRate = 0;
    }
}

- (void)update {
    if (self.accelerating) {
        [self.physicsBody applyForce:CGVectorMake(0.0, 100)];
    }
    if(!self.crashed)
    {
        self.zRotation = fmaxf(fminf(self.physicsBody.velocity.dy, 400), -400) / 400;
        //self.engineSound.volume = 0.25 + fmaxf(fminf(self.physicsBody.velocity.dy, 300), 0) / 300 * 0.75;
    }
}



@end
