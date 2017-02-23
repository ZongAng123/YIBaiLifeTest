//
//  CustomNavBar.h
//  YiBaiLifeTest
//
//  Created by Earl on 16/7/7.
//  Copyright (c) 2016年 Earl. All rights reserved.
//

#import <UIKit/UIKit.h>

//声明一个协议
//@protocol CustomNavBarDelegate <NSObject>
//
//- (void)backLastVC;
//
//@end


@interface CustomNavBar : UIView
//自定义初始化方法
- (id)initWithNavBarTitle:(NSString *)title;
//代理对象用assgin 
//@property (nonatomic, assign)id<CustomNavBarDelegate>delegate;
//属性传值
//@property (nonatomic, strong)UIViewController *VC;
@property (nonatomic, strong)UIButton *backButton;
@end
