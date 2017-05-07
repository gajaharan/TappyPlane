//
//  TCollectable.h
//  Tappy Plane
//
//  Created by Gajaharan Satkunanandan on 06/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class TCollectable;

@protocol TCollectableDelegate <NSObject>

-(void)wasCollected:(TCollectable*)collectable;

@end

@interface TCollectable : SKSpriteNode

@property (nonatomic, weak) id<TCollectableDelegate> delegate;
@property (nonatomic) NSInteger pointValue;

-(void)collect;

@end
