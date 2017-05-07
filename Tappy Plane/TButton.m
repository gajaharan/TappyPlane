//
//  TButton.m
//  Tappy Plane
//
//  Created by Gajaharan Satkunanandan on 07/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import "TButton.h"
#import <objc/message.h>

@interface TButton()

@property (nonatomic) CGRect fullSizeFrame;
@property (nonatomic) BOOL pressed;

@end

@implementation TButton

+(instancetype)spriteNodeWithTexture:(SKTexture *)texture {
    TButton *instance = [super spriteNodeWithTexture:texture];
    instance.pressedScale = 0.9;
    instance.userInteractionEnabled = YES;
    return instance;
}

-(void)setPressedTarget:(id)pressedTarget withAction:(SEL)pressedAction {
    _pressedTarget = pressedTarget;
    _pressedAction = pressedAction;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.fullSizeFrame = self.frame;
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (self.pressed != CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            self.pressed = !self.pressed;
            if (self.pressed) {
                [self setScale:self.pressedScale];
                //[self.pressedSound play];
            } else {
                [self setScale:1.0];
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setScale:1.0];
    self.pressed = NO;
    for (UITouch *touch in touches) {
        if (CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            // Pressed button.<#(id)#>
            //[self.pressedTarget performSelector:self.pressedAction];
            objc_msgSend(self.pressedTarget, self.pressedAction);
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setScale:1.0];
    self.pressed = NO;
}

@end
