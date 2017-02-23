//
//  CityViewController.m
//  YiBaiLifeTest
//
//  Created by Earl on 16/7/6.
//  Copyright (c) 2016年 Earl. All rights reserved.
//

#import "CityViewController.h"
#import "CustomNavBar.h"
//定义宏 屏幕宽度和高度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface CityViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *bigScrollView;
@property (nonatomic ,strong)UIScrollView *smallScrollView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)NSMutableArray *buttonArray;
@end

@implementation CityViewController
//数组懒加载
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        self.buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
//小滑动视图的懒加载
- (UIScrollView *)smallScrollView {
    if (!_smallScrollView) {
        self.smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        //设置整屏滑动
        _smallScrollView.pagingEnabled = YES;
        //设置水平滑动指示器不显示
        _smallScrollView.showsHorizontalScrollIndicator = NO;
        //设置内容区域大小
        _smallScrollView.contentSize = CGSizeMake(kScreenWidth * 5, 200);
        //设置代理
        _smallScrollView.delegate = self;
    }
    return _smallScrollView;
}
//页面控制的懒加载
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 180, kScreenWidth, 20)];
        //设置几个点
        _pageControl.numberOfPages = 5;
        //设置未选择的点的颜色
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        //设置选择的点的颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [_pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}
//大的滑动视图懒加载
- (UIScrollView *)bigScrollView {
    if (!_bigScrollView) {
        self.bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
        //计算间距
        float speedX = (kScreenWidth - 3 * 72) / 4;
        //设置内容区域的大小
        _bigScrollView.contentSize = CGSizeMake(kScreenWidth, 200 + speedX + 4 * (72 + speedX));
        //添加小的滑动视图
        [_bigScrollView addSubview:self.smallScrollView];
        //添加pageControl
        [_bigScrollView addSubview:self.pageControl];
    }
    return _bigScrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    //导航条
    CustomNavBar *barView = [[CustomNavBar alloc] initWithNavBarTitle:@"城市"];
    [self.view addSubview:barView];
    
    //添加大的滑动视图
    [self.view addSubview:self.bigScrollView];
    //利用for循环创建图片给小滑动视图
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, 200)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c_item%d.jpg",i]];
        [self.smallScrollView addSubview:imageView];
    }
    //创建定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    
    //计算间距
    float speedX = (kScreenWidth - 3 * 72) / 4;
    //利用for循环创建12个button
    for (int i = 0; i < 12; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(speedX + i % 3 * (72 + speedX), 200 + speedX + i / 3 * (72 + speedX), 72, 72);
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"c_%d",i + 1]] forState:UIControlStateNormal];
        [self.bigScrollView addSubview:button];
    }
    //利用for循环创建4个按钮
    for (int i = 0; i < 4; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 45, 45);
        button.center = CGPointMake(kScreenWidth - 30, kScreenHeight - 30);
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"c_setting%d",3 - i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        //将创建的button添加进数组中
        [self.buttonArray addObject:button];
    }
    
}
- (void)buttonAction:(UIButton *)button {
    //
    static BOOL isOrClose = YES;
    
    if (isOrClose == YES) {
        //散开
        
         //通过for循环遍历所有的button修改他们的中心点
        for (int i = 0; i < self.buttonArray.count; i++) {
            UIButton *button = self.buttonArray[i];
            [UIView animateWithDuration:0.5 animations:^{
                button.center = CGPointMake(button.center.x - (1 - i % 2) * 60, button.center.y - (1 - i / 2) * 60);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    button.center = CGPointMake(button.center.x + (1 - i % 2) * 10, button.center.y + (1 - i / 2) * 10);
                }];
                
            }];
        }
        
    }else {
       //合住
        //通过for循环遍历所有的button 修改中心点
        for (int i = 0; i < self.buttonArray.count; i++) {
            UIButton *button = self.buttonArray[i];
            
            [UIView animateWithDuration:0.5 animations:^{
                button.center = CGPointMake(button.center.x - (1 - i % 2) * 10, button.center.y - (1 - i / 2) * 10);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    button.center = CGPointMake(kScreenWidth - 30, kScreenHeight - 30);
                }];
            }];
        }

    }
    //每次点击之后，都修改它的状态（为上一次状态的反值）
    isOrClose = !isOrClose;
    
}
//定时器绑定方法
- (void)autoScroll {
    //声明一个静态的偏移增量
    static float offset = 0;
    //当小的滑动视图的x方向上的偏离量为0时，让偏移增量为正
    if (self.smallScrollView.contentOffset.x / kScreenWidth == 0) {
        offset = kScreenWidth;
    }
    //当小的滑动视图的x方向上的偏离量为4 * w 时，让偏移增量为负
    if (self.smallScrollView.contentOffset.x / kScreenWidth == 4) {
        offset = -kScreenWidth;
    }

    [UIView animateWithDuration:0.5 animations:^{
        [self.smallScrollView setContentOffset:CGPointMake(self.smallScrollView.contentOffset.x + offset, 0)];
        self.pageControl.currentPage = self.smallScrollView.contentOffset.x / kScreenWidth;
    }];
    
}
//滑动结束的时候执行的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //根据滑动视图的便宜量，来设置页面控制的当前页
    self.pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
}
- (void)pageControlAction:(UIPageControl *)pageControl {
    //根据点击页面控制来设置滑动视图的偏移量
    [self.smallScrollView setContentOffset:CGPointMake(pageControl.currentPage * kScreenWidth, 0) animated:YES];
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
