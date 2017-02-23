//
//  WeatherViewController.m
//  YiBaiLifeTest
//
//  Created by Earl on 16/7/6.
//  Copyright (c) 2016年 Earl. All rights reserved.
//

#import "WeatherViewController.h"
#import "CustomNavBar.h"
#import "CenterImageView.h"
//定义宏 屏幕宽度和高度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface WeatherViewController ()
//白天或者夜晚的按钮
@property (nonatomic, strong)UIButton *dayOrNightButton;
//声明一个被选中的button属性，用来记录选中按钮
@property (nonatomic, strong)UIButton *selectedButton;
//标签指示视图
@property (nonatomic, strong)UIImageView *tipImgView;
@property (nonatomic, strong)CenterImageView *centerImgView;
@end

@implementation WeatherViewController

#pragma mark - 懒加载 加载视图或者数组资源
- (UIButton *)dayOrNightButton {
    if (!_dayOrNightButton) {
        self.dayOrNightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dayOrNightButton.frame = CGRectMake(kScreenWidth - 80, 20, 60, 44);
        //设置正常状态和选中状态下的标题
        [_dayOrNightButton setTitle:@"白天" forState:UIControlStateNormal];
        [_dayOrNightButton setTitle:@"夜晚" forState:UIControlStateSelected];
        [_dayOrNightButton addTarget:self action:@selector(dayOrNightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dayOrNightButton;
}
//白天夜晚button的点击方法实现
- (void)dayOrNightButtonAction:(UIButton *)button {
    //改变button的选中状态，最开始为未选中状态，点击之后，修改为选中状态，每次点击都修改为不同的状态
    button.selected = !button.selected;
    //通过点击白天黑夜按钮来切换天气
    [self.centerImgView changeWeatherWithIsOrNight:button.selected andWeekButtonTag:self.selectedButton.tag];
}
//标签视图懒加载
- (UIImageView *)tipImgView {
    if (!_tipImgView) {
        self.tipImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 91, 11)];
        _tipImgView.center = CGPointMake(self.selectedButton.center.x, self.tipImgView.center.y);
        _tipImgView.image = [UIImage imageNamed:@"w_tip"];
    }
    return _tipImgView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading    the view.
   //创建背景视图
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgView.image = [UIImage imageNamed:@"w_bg"];
    [self.view addSubview:bgView];
    
    
    //创建导航条
    CustomNavBar *barView = [[CustomNavBar alloc] initWithNavBarTitle:@"天气"];
    [self.view addSubview:barView];
    //添加按钮
    [barView addSubview:self.dayOrNightButton];
    
    //创建一个滑动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 73, kScreenWidth, 73)];
    scrollView.contentSize = CGSizeMake(7 * (10 + 91), 73);
    [self.view addSubview:scrollView];
    //添加按钮周一至周日
    NSArray *weekArray = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    for (int i = 0; i < weekArray.count; i++) {
        UIButton *weekButton = [UIButton buttonWithType:UIButtonTypeCustom];
        weekButton.frame = CGRectMake(5 + i * (91 + 10), 10, 91, 53);
        weekButton.tag = i;
        //设置标题
        [weekButton setTitle:weekArray[i] forState:UIControlStateNormal];
         //设置不同状态下，背景图片
        [weekButton setBackgroundImage:[UIImage imageNamed:@"w_xq2"] forState:UIControlStateNormal];
        [weekButton setBackgroundImage:[UIImage imageNamed:@"w_xq1"] forState:UIControlStateSelected];
        //设置不同状态下，字体颜色
        [weekButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [weekButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [weekButton addTarget:self action:@selector(weekButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            //当i==0的时候，将第一个按钮的状态修改为选中状态，因为默认为周一被选中，并且来记录这个被选中的按钮
            weekButton.selected = YES;
            self.selectedButton = weekButton;
            [scrollView addSubview:self.tipImgView];
        }
        [scrollView addSubview:weekButton];
    }
    //创建中心视图
    self.centerImgView = [[CenterImageView alloc] initWithFrame:CGRectMake(0, 0, 284, 291)];
    self.centerImgView.center = CGPointMake(self.view.center.x, self.view.center.y - 12);
    self.centerImgView.image = [UIImage imageNamed:@"w_qing"];
    [self.view addSubview:self.centerImgView];
    
}
- (void)weekButtonAction:(UIButton *)button {
    //当点中按钮时，先让上一个button的状态修改为未选中
    self.selectedButton.selected = NO;
    //然后修改自己为选中状态
    button.selected = YES;
    //重新标记被选中的按钮
    self.selectedButton = button;
    
    //修改指示视图的位置
    self.tipImgView.center = CGPointMake(button.center.x, self.tipImgView.center.y);
    //通过按钮点击方法来修改中心视图的内容
    [self.centerImgView changeWeatherWithIsOrNight:self.dayOrNightButton.selected andWeekButtonTag:button.tag];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
