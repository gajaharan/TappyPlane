//
//  TScrollingLayer.m
//  Tappy Plane
//
//  Created by Gajaharan Satkunanandan on 06/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import "TScrollingLayer.h"

@interface TScrollingLayer()

@property (nonatomic) SKSpriteNode *rightmostTile;

@end

@implementation TScrollingLayer

-(id)initWithTiles:(NSArray *)tileSpriteNodes {
    if (self = [super init]) {
        for (SKSpriteNode *tile in tileSpriteNodes) {
            tile.anchorPoint = CGPointZero;
            tile.name = @"Tile";
            [self addChild:tile];
        }
        
        [self layoutTiles];
        
    }
    return self;
}

-(void)layoutTiles {
    self.rightmostTile = nil;
    [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
        node.position = CGPointMake(self.rightmostTile.position.x +
                                    self.rightmostTile.size.width, node.position.y);
        self.rightmostTile = (SKSpriteNode*)node;
    }];
}

-(void)updateWithTimeElpased:(NSTimeInterval)timeElapsed {
    [super updateWithTimeElpased:timeElapsed];
    
    if (self.scrolling && self.horizontalScrollSpeed < 0 && self.scene) {
        // Convert position of tile into coordinate system
        [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
            CGPoint nodePostionInScene = [self convertPoint:node.position toNode:self.scene];
            
            // Is the right hand edge of tile is less than the the left hand of the scene
            if (nodePostionInScene.x + node.frame.size.width <
                -self.scene.size.width * self.scene.anchorPoint.x) {
                node.position = CGPointMake(self.rightmostTile.position.x +
                                            self.rightmostTile.size.width, node.position.y);
                // If so pick that tile to be placed on the most right hand side.
                self.rightmostTile = (SKSpriteNode*)node;
            }
        }];
        
    }
    
}

@end
