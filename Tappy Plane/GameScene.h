//
//  GameScene.h
//  Tappy Plane
//

//  Copyright (c) 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TCollectable.h"
#import "TGameOverMenu.h"

static const CGFloat minFPS = 10.0 / 60.0;
static NSString *const KEY_BEST_SCORE = @"BestScore";

@interface GameScene : SKScene <SKPhysicsContactDelegate, TCollectableDelegate, TGameOverMenuDelegate>

@end
