//
//  MainButton.h
//  YiBaiLifeTest
//
//  Created by Earl on 16/7/6.
//  Copyright (c) 2016年 Earl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainButton : UIButton
//声明一个button视图的角度，要设置成整形，为了后面的取余运算
//基本数据类型和代理用assgin
//对象类型用strong
@property (nonatomic, assign)int angle;


@end
