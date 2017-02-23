//
//  TopView.m
//  YiBaiLifeTest
//
//  Created by Earl on 16/7/7.
//  Copyright (c) 2016年 Earl. All rights reserved.
//

#import "TopView.h"
//定义宏 屏幕宽度和高度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation TopView
//重写父类的初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super init];
//    if (self) {
//        self.frame = frame;
//        //自己的
//    }
    self = [super initWithFrame:frame];
    if (self) {
        //自己的
        //设置自己的子视图如果超出自己的部分隐藏
        self.clipsToBounds = YES;
        //self.layer.masksToBounds = YES;
        //导航条
        UIImageView *topBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        topBarView.image = [UIImage imageNamed:@"commonNavBar"];
        [self addSubview:topBarView];
        //创建菜单栏按钮
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(10, 25, 20, 16);
        [menuButton setBackgroundImage:[UIImage imageNamed:@"n_menu"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(menuButtonActin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuButton];
        //创建标题label
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 70) / 2, 0, 70, 64)];
        self.titleLabel.text = @"头条";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        //创建内容视图
        self.contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
        self.contentImageView.image = [UIImage imageNamed:@"news_1"];
        [self addSubview:self.contentImageView];
    }
    return self;
}
- (void)menuButtonActin {
    //判断topView的视图起始点位置是否在原点，如果在原点则让其移动到新位置，如果在不在原点则让其移动到原点位置
    
    if (self.frame.origin.x == 0) {
        //动画移动下去
        
        [UIView animateWithDuration:1 animations:^{
            self.frame = CGRectMake(kScreenWidth - 180, 120, 180, 300);
            self.titleLabel.frame= CGRectMake(30, 0, 70, 64);
        }];
        
        
    }else {
        //动画移动回来
        
        [UIView animateWithDuration:1 animations:^{
            self.frame = [UIScreen mainScreen].bounds;
            self.titleLabel.frame = CGRectMake((kScreenWidth - 70) / 2, 0, 70, 64);
        }];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
