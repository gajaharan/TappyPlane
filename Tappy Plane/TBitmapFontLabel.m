//
//  TPBitmapFontLabel.m
//  Tappy Plane
//
//  Created by Gajaharan Satkunanandan on 07/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import "TBitmapFontLabel.h"

@implementation TBitmapFontLabel

-(instancetype)initWithText:(NSString *)text andFontName:(NSString *)fontName {
    if (self = [super init]) {
        _text = text;
        _fontName = fontName;
        _letterSpacing = 2.0;
        _alignment = BitmapFontAlignmentCenter;
        [self updateText];
    }
    return self;
}

-(void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        [self updateText];
    }
}

-(void)setFontName:(NSString *)fontName {
    if (_fontName != fontName) {
        _fontName = fontName;
        [self updateText];
    }
}

-(void)setLetterSpacing:(CGFloat)letterSpacing {
    if (_letterSpacing != letterSpacing) {
        _letterSpacing = letterSpacing;
        [self updateText];
    }
}

-(void)setAlignment:(BitmapFontAlignment)alignment {
    if (_alignment != alignment) {
        _alignment = alignment;
        [self updateText];
    }
}

-(void)updateText {
    // Remove unused nodes.
    if (self.text.length < self.children.count) {
        for (NSUInteger i = self.children.count; i > self.text.length; i--) {
            [[self.children objectAtIndex:i-1] removeFromParent];
        }
    }
    
    CGPoint pos = CGPointZero;
    CGSize totalSize = CGSizeZero;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    // Loop through all characters in text.
    for (NSUInteger i = 0; i < self.text.length; i++) {
        // Get character in text for current position in loop.
        unichar c = [self.text characterAtIndex:i];
        // Build texture name from character and font name.
        NSString *textureName = [NSString stringWithFormat:@"%@%C", self.fontName, c];
        
        SKSpriteNode *letter;
        if (i < self.children.count) {
            // Reuse an existing node.
            letter = [self.children objectAtIndex:i];
            letter.texture = [atlas textureNamed:textureName];
            letter.size = letter.texture.size;
        } else {
            // Create a new letter node.
            letter = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:textureName]];
            letter.anchorPoint = CGPointZero;
            [self addChild:letter];
        }
        
        letter.position = pos;
        
        pos.x += letter.size.width + self.letterSpacing;
        totalSize.width += letter.size.width + self.letterSpacing;
        if (totalSize.height < letter.size.height) {
            totalSize.height = letter.size.height;
        }
    }
    
    if (self.text.length > 0) {
        totalSize.width -= self.letterSpacing;
    }
    
    // Set text alignment
    CGPoint adjustment;
    
    switch (self.alignment) {
        case BitmapFontAlignmentLeft:
            adjustment = CGPointMake(0.0, -totalSize.height * 0.5);
            break;
        case BitmapFontAlignmentCenter:
            adjustment = CGPointMake(-totalSize.width * 0.5, -totalSize.height * 0.5);
            break;
        case BitmapFontAlignmentRight:
            adjustment = CGPointMake(-totalSize.width, -totalSize.height * 0.5);
            break;
        default:
            break;
    }
    
    for (SKNode *letter in self.children) {
        letter.position = CGPointMake(letter.position.x + adjustment.x, letter.position.y + adjustment.y);
    }
    
    
}

@end
