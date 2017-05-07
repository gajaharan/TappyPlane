//
//  TButton.h
//  Tappy Plane
//
//  Created by Gajaharan Satkunanandan on 07/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TButton : SKSpriteNode

@property (nonatomic, readonly, weak) id pressedTarget;
@property (nonatomic, readonly) SEL pressedAction;
@property (nonatomic) CGFloat pressedScale;

-(void)setPressedTarget:(id)pressedTarget withAction:(SEL)pressedAction;

+(instancetype)spriteNodeWithTexture:(SKTexture *)texture;

@end
