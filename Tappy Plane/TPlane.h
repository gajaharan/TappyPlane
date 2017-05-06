//
//  TPlane.h
//  Tappy Plane
//
//  Created by Gajaharan Satkunanandan on 02/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static NSString* const TPKEY_PlANE_ANIMATION = @"PlaneAnimation";
static const CGFloat MAX_ALTITUDE = 300.0;

@interface TPlane : SKSpriteNode

@property (nonatomic) BOOL engineRunning;
@property (nonatomic) BOOL accelerating;
@property (nonatomic) BOOL crashed;

- (void)setRandomColour;
- (void)update;
- (void)collide:(SKPhysicsBody*)body;
- (void)reset;

@end
