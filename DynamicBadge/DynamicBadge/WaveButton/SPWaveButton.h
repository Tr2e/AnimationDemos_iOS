//
//  SPWaveButton.h
//  DynamicBadge
//
//  Created by Tree on 2017/6/4.
//  Copyright © 2017年 Tr2e. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPWaveBtnAnimateType){

    BtnAnimateTypeWave,
    BtnAnimateTypeRotatedCircle
    
};

@interface SPWaveButton : UIButton

- (void)makeWaveWithButton:(UIButton *)button andEvent:(UIEvent *)event;
- (void)makeRotateCircleWithRadius:(CGFloat) radius;

- (void)completeAnimation;

@end

