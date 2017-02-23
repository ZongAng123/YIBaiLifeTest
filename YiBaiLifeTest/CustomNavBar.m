//
//  CustomNavBar.m
//  YiBaiLifeTest
//
//  Created by Earl on 16/7/7.
//  Copyright (c) 2016年 Earl. All rights reserved.
//

#import "CustomNavBar.h"
//定义宏 屏幕宽度和高度

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation CustomNavBar
- (id)initWithNavBarTitle:(NSString *)title {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    if (self) {
        //创建背景
        //背景图片 使用bounds的话，不会因为父视图的位置修改影响到图片视图的位置，这样就和父视图的位置重合，并且大小相等
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgView.image = [UIImage imageNamed:@"commonNavBar"];
        [self addSubview:bgView];
        //标题label的创建
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        //返回按钮
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(10, 30, 20, 19);
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
        
    }
    return self;
}
- (void)backButtonAction {
    //第一种方法 使用代理
    //点击按钮之后，由于自己无法返回，就让自己的代理去做返回操作，首先要判断代理对象是否存在，并且是否能够响应代理方法，如果二者满足了，才去让代理对象去执行
//    if (self.delegate && [self.delegate respondsToSelector:@selector(backLastVC)]) {
//        [self.delegate backLastVC];
//    }
    //第二种方法 找到父视图所在的视图控制器对象
    //nextResponder 下一个响应者 （如果一个视图有被视图控制器管理，那么该视图的下一个响应者就是这个视图控制器）
    UIViewController *responderVC = (UIViewController *)self.superview.nextResponder;
    NSLog(@"%@",self.nextResponder);
    NSLog(@"%@",self.superview.nextResponder);

    [responderVC.navigationController popViewControllerAnimated:YES];
    //第三种方式 传值
    //属性传
    //[self.VC.navigationController popViewControllerAnimated:YES];
    //第四种 将button按钮的点击方法放在视图控制器里来添加，这样方法里就可以获取到那个视图控制器对象，前提视图必须把button设置成属性
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
