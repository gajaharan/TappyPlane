//
//  TObstacleLayer.h
//  Tappy Plane
//
//  Created by Gajaharan Satkunanandan on 06/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import "TScrollingNode.h"

@interface TObstacleLayer : TScrollingNode

//@property (nonatomic, weak) id<TCollectableDelegate> collectableDelegate;

@property (nonatomic) CGFloat floor;
@property (nonatomic) CGFloat ceiling;

-(void)reset;

@end
