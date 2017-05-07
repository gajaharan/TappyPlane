//
//  TGameOverMenu.h
//  Tappy Plane
//
//  Created by Gajaharan Satkunanandan on 07/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    MedalNone,
    MedalBronze,
    MedalSilver,
    MedalGold,
} MedalType;

@protocol TGameOverMenuDelegate <NSObject>

-(void)pressedStartNewGameButton;

@end

@interface TGameOverMenu : SKNode

@property (nonatomic) CGSize size;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger bestScore;
@property (nonatomic) MedalType medal;
@property (nonatomic, weak) id<TGameOverMenuDelegate> delegate;

-(instancetype)initWithSize:(CGSize)size;
-(void)show;

@end
