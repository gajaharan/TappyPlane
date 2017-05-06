//
//  TScrollingLayer.h
//  Tappy Plane
//
//  Created by Gajaharan Satkunanandan on 06/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import "TScrollingNode.h"

@interface TScrollingLayer : TScrollingNode

-(id)initWithTiles:(NSArray*)tileSpriteNodes;

-(void)layoutTiles;

@end
