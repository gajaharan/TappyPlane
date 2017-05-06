//
//  TObstacleLayer.m
//  Tappy Plane
//
//  Created by Gajaharan Satkunanandan on 06/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import "TObstacleLayer.h"
#import "TConstants.h"

@interface TObstacleLayer()

@property (nonatomic) CGFloat marker;

@end

static const CGFloat MARKER_BUFFER = 200.0;
static const CGFloat VERTICAL_GAP = 90.0;
static const CGFloat SPACE_BETWEEN_OBSTACLE_SETS = 180.0;
static const int COLLECTABLE_VECTOR_RANGE = 200.0;
static const CGFloat COLLECTABLE_CLEARANCE = 50.0;

static NSString *const KEY_MOUNTAIN_UP = @"MountainUp";
static NSString *const KEY_MOUNTAIN_DOWN = @"MountainDown";
static NSString *const KEY_COLLECTABLE_STAR = @"CollectableStar";

@implementation TObstacleLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        //load initial objects
        //for (int i=0; i<5; i++) {
        //    [self createObjectForKey:KEY_MOUNTAIN_UP].position = CGPointMake(-1000, 0);
        //    [self createObjectForKey:KEY_MOUNTAIN_DOWN].position = CGPointMake(-1000, 0);
        //}
    }
    return self;
}

-(void)updateWithTimeElpased:(NSTimeInterval)timeElapsed
{
    [super updateWithTimeElpased:timeElapsed];
    
    if (self.scrolling && self.scene) {
        // Find marker's location in scene coords.
        CGPoint markerLocationInScene = [self convertPoint:CGPointMake(self.marker, 0) toNode:self.scene];
        // When marker comes onto screen, add new obstacles.
        if (markerLocationInScene.x - (self.scene.size.width * self.scene.anchorPoint.x)
            < self.scene.size.width + MARKER_BUFFER) {
            [self addObstacleSet];
        }
    }
    
}



-(void)addObstacleSet
{
    // Get mountain nodes.
    SKSpriteNode *mountainUp = [self getUnusedObjectForKey:KEY_MOUNTAIN_UP];
    SKSpriteNode *mountainDown = [self getUnusedObjectForKey:KEY_MOUNTAIN_DOWN];
    //SKSpriteNode *mountainUp = [self createObjectForKey:KEY_MOUNTAIN_UP];
    //SKSpriteNode *mountainDown = [self createObjectForKey:KEY_MOUNTAIN_DOWN];
    
    // Calculate maximum variation.
    CGFloat maxVariation = (mountainUp.size.height + mountainDown.size.height + VERTICAL_GAP) - (self.ceiling - self.floor);
    CGFloat yAdjustment = (CGFloat)arc4random_uniform(maxVariation);
    
    // Postion mountain nodes.
    mountainUp.position = CGPointMake(self.marker, self.floor + (mountainUp.size.height * 0.5) - yAdjustment);
    mountainDown.position = CGPointMake(self.marker, mountainUp.position.y + mountainDown.size.height + VERTICAL_GAP);
    
//    // Get collectable star node.
//    SKSpriteNode *collectable = [self getUnusedObjectForKey:KEY_COLLECTABLE_STAR];
//    
//    // Position collectable.
//    CGFloat midPoint = mountainUp.position.y + (mountainUp.size.height * 0.5) + (kTPVerticalGap * 0.5);
//    CGFloat yPosition = midPoint + arc4random_uniform(kTPCollectableVerticalRange) - (kTPCollectableVerticalRange * 0.5);
//    
//    yPosition = fmaxf(yPosition, self.floor + kTPCollectableClearance);
//    yPosition = fminf(yPosition, self.ceiling - kTPCollectableClearance);
//    
//    collectable.position = CGPointMake(self.marker + (kTPSpaceBetweenObstacleSets * 0.5), yPosition);
//    
    // Reposition marker.
    self.marker += SPACE_BETWEEN_OBSTACLE_SETS;
    
}

-(SKSpriteNode*)createObjectForKey:(NSString*)key
{
    SKSpriteNode *object = nil;
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    if (key == KEY_MOUNTAIN_UP) {
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrass"]];

        //object = [SKSpriteNode spriteNodeWithTexture:[[TPTilesetTextureProvider getProvider] getTextureForKey:@"mountainUp"]];
        
        CGFloat offsetX = object.frame.size.width * object.anchorPoint.x;
        CGFloat offsetY = object.frame.size.height * object.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 55 - offsetX, 199 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 0 - offsetY);
        CGPathCloseSubpath(path);
        
        object.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        object.physicsBody.categoryBitMask = CATEGORY_GROUND;
        
        [self addChild:object];
    }
    else if (key == KEY_MOUNTAIN_DOWN) {
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrassDown"]];
        //object = [SKSpriteNode spriteNodeWithTexture:[[TPTilesetTextureProvider getProvider] getTextureForKey:@"mountainDown"]];
        
        CGFloat offsetX = object.frame.size.width * object.anchorPoint.x;
        CGFloat offsetY = object.frame.size.height * object.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0 - offsetX, 199 - offsetY);
        CGPathAddLineToPoint(path, NULL, 55 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 199 - offsetY);
        CGPathCloseSubpath(path);
        
        object.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        object.physicsBody.categoryBitMask = CATEGORY_GROUND;
        
        [self addChild:object];
//    } else if (key == kTPKeyCollectableStar) {
//        object = [TPCollectable spriteNodeWithTexture:[atlas textureNamed:@"starGold"]];
//        ((TPCollectable*)object).pointValue = 1;
//        ((TPCollectable*)object).delegate = self.collectableDelegate;
//        ((TPCollectable*)object).collectionSound = [Sound soundNamed:@"Collect.caf"];
//        object.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:object.size.width * 0.3];
//        object.physicsBody.categoryBitMask = kTPCategoryCollectable;
//        object.physicsBody.dynamic = NO;
        
        //[self addChild:object];
    }
    
    if (object) {
        object.name = key;
    }
    
    return object;
}

-(SKSpriteNode*)getUnusedObjectForKey:(NSString*)key
{
    if (self.scene) {
        // Get left edge of screen in local coordinates.
        CGFloat leftEdgeInLocalCoords = [self.scene convertPoint:CGPointMake(-self.scene.size.width * self.scene.anchorPoint.x, 0) toNode:self].x;
        
        // Try find object for key to the left of the screen.
        for (SKSpriteNode* node in self.children) {
            if (node.name == key && node.frame.origin.x + node.frame.size.width < leftEdgeInLocalCoords) {
                // Return unused object.
                return node;
            }
        }
    }
    
    // Couldn't find an unused node with key so create a new one.
    return [self createObjectForKey:key];
}

-(void)reset
{
    // Loop through child nodes and reposition for reuse and update texture.
    for (SKNode *node in self.children) {
        node.position = CGPointMake(-1000, 0);
        //if (node.name == KEY_MOUNTAIN_UP) {
        //    ((SKSpriteNode*)node).texture = [[TPTilesetTextureProvider getProvider] getTextureForKey:@"mountainUp"];
        //}
        //if (node.name == kTPKeyMountainDown) {
        //    ((SKSpriteNode*)node).texture = [[TPTilesetTextureProvider getProvider] getTextureForKey:@"mountainDown"];
        //}
    }
    
    // Reposition marker.
    if (self.scene) {
        self.marker = self.scene.size.width + MARKER_BUFFER;
    }
}

@end
