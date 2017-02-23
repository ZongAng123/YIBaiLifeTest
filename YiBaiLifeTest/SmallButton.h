//
//  SmallButton.h
//  YiBaiLifeTest
//
//  Created by Earl on 16/7/5.
//  Copyright (c) 2016年 Earl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BigImageView.h"
@interface SmallButton : UIButton
//记录button的位置是在上面还是下面，根据这个属性来判断button的位置
@property (nonatomic, assign) BOOL isOrUp;
//记录button最初始的位置中心点坐标
@property (nonatomic ,assign)CGPoint downCenter;
//记录button下方的bigImageView
@property (nonatomic, strong)BigImageView *bottomImageView;


@end
