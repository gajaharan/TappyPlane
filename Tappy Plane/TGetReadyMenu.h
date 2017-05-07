//
//  TGetReadyMenu.h
//  Tappy Plane
//
//  Created by Gajaharan Satkunanandan on 07/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TGetReadyMenu : SKNode

@property (nonatomic) CGSize size;

-(instancetype)initWithSize:(CGSize)size andPlanePosition:(CGPoint)planePosition;

-(void)show;
-(void)hide;

@end
