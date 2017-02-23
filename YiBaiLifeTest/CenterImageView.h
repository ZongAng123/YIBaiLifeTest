//
//  CenterImageView.h
//  YiBaiLifeTest
//
//  Created by Earl on 16/7/9.
//  Copyright (c) 2016年 Earl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterImageView : UIImageView
//根据判断是白天还是夜晚 和 点击的是周几来确定天气
- (void)changeWeatherWithIsOrNight:(BOOL)isNight andWeekButtonTag:(NSInteger)tag;

@end
