//
//  TScrollingNode.h
//  Tappy Plane
//
//  Created by Gajaharan Satkunanandan on 06/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TScrollingNode : SKSpriteNode


@property (nonatomic) CGFloat horizontalScrollSpeed; // Distance to scroll per second.
@property (nonatomic) BOOL scrolling;

- (void)updateWithTimeElpased:(NSTimeInterval)timeElapsed;


@end
