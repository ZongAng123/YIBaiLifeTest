//
//  TopView.h
//  YiBaiLifeTest
//
//  Created by Earl on 16/7/7.
//  Copyright (c) 2016年 Earl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopView : UIView
//标题label (放在.h为了让外部访问到，修改其位置)
@property (nonatomic, strong) UILabel *titleLabel;
//内容图片视图(放在.h为了让外部访问到，修改其图片)
@property (nonatomic, strong)UIImageView *contentImageView;

@end
