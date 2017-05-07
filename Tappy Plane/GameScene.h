//
//  GameScene.h
//  Tappy Plane
//

//  Copyright (c) 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TCollectable.h"

static const CGFloat minFPS = 10.0 / 60.0;

@interface GameScene : SKScene <SKPhysicsContactDelegate, TCollectableDelegate>

@end
