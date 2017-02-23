//
//  NewsViewController.m
//  YiBaiLifeTest
//
//  Created by Earl on 16/7/6.
//  Copyright (c) 2016年 Earl. All rights reserved.
//

#import "NewsViewController.h"
#import "TopView.h"
//定义宏 屏幕宽度和高度

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface NewsViewController ()
//设置选择的按钮的背景条
@property (nonatomic, strong)UIView *selectedBgView;
@property (nonatomic, strong)TopView *topView;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建背景视图
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgView.image = [UIImage imageNamed:@"n_background"];
    [self.view addSubview:bgView];
    //for循环创建6个按钮
    for (int i = 0; i < 6; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 45 + i * (45 + 20),kScreenWidth , 45);
//        button.backgroundColor = [UIColor lightGrayColor];
//        button.alpha = 0.3;
        //设置tag值
        button.tag = i;
        //添加方法
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        //当i==0的时候创建选择的button后的背景条，默认为第一个
        if (i == 0) {
            self.selectedBgView = [[UIView alloc] initWithFrame:button.frame];
            self.selectedBgView.backgroundColor = [UIColor lightGrayColor];
            //设置透明度
            self.selectedBgView.alpha = 0.3;
            [self.view addSubview:self.selectedBgView];
        }
        //由于背景条和第一个button的位置相同，为了不背景条挡住button，所以应该先添加背景条，在添加button
        [self.view addSubview:button];
    }
    
    //创建返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, kScreenHeight - 39 , 20, 19);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //创建topView
    self.topView = [[TopView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.topView];
    
}

- (void)buttonAction:(UIButton *)button {
    
   [UIView animateWithDuration:1 animations:^{
       //修改按钮背景条位置
       self.selectedBgView.frame = button.frame;
       //修改topView的位置
       self.topView.frame = self.view.frame;
       self.topView.titleLabel.frame = CGRectMake((kScreenWidth - 70) / 2, 0, 70, 64);
   }];
    //标题数组
    NSArray *titleArray = @[@"头条",@"娱乐",@"体育",@"科技",@"财经",@"时尚"];
    //图片数组
    NSArray *imageArray = @[@"news_1",@"news_2",@"news_3",@"news_4",@"news_5",@"news_6"];
    //修改topView上的标题和内容图片
    self.topView.titleLabel.text = titleArray[button.tag];
    self.topView.contentImageView.image = [UIImage imageNamed:imageArray[button.tag]];
}
- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
    
//    [UIApplication sharedApplication].delegate
//    [UIApplication sharedApplication].keyWindow
//[UIApplication sharedApplication].windows[0]
   // self.view.window
    
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
