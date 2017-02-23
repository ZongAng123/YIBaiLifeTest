//
//  SearchViewController.m
//  YiBaiLifeTest
//
//  Created by Earl on 16/7/6.
//  Copyright (c) 2016年 Earl. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomNavBar.h"
//定义宏 屏幕宽度和高度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface SearchViewController ()//<CustomNavBarDelegate>
@property (nonatomic, strong)UIView *redLineView;
@property (nonatomic, strong)UIWebView *webView;

@end

@implementation SearchViewController
//红色视图懒加载
- (UIView *)redLineView {
    if (!_redLineView) {
        self.redLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, 79, 2)];
        _redLineView.backgroundColor = [UIColor redColor];
    }
    return _redLineView;
}
//网页视图懒加载
- (UIWebView *)webView {
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight - 100)];
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}
- (void)creatUI {
   //创建导航条
    CustomNavBar *barView = [[CustomNavBar alloc] initWithNavBarTitle:@"搜索"];
    //barView.delegate = self;
    //属性传
    //barView.VC = self;
    //[barView.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:barView];
    
    //创建滑动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64,kScreenWidth, 36)];
    //关闭横向指示器
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    //利用for循环创建button
    NSArray *titleArray = @[@"百度",@"腾讯",@"糗百",@"新浪",@"虎牙",@"斗鱼",@"优酷",@"搜狐"];
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(80 * i, 0, 79, 34);
        //button 设置tag值
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor grayColor];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
    }
    //设置滑动视图的内容区域
    scrollView.contentSize = CGSizeMake(titleArray.count * 80 - 1, 36);
    //添加红色下划线视图
    [scrollView addSubview:self.redLineView];
    
    //添加网页视图
    [self.view addSubview:self.webView];
    //1.通过字符串生成一个URL链接
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    //2.将网络链接转换成网络请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.用网页视图来加载网络请求对象
    [self.webView loadRequest:request];
    
}
- (void)buttonAction:(UIButton *)button {
    [UIView animateWithDuration:0.5 animations:^{
        self.redLineView.center = CGPointMake(button.center.x, self.redLineView.center.y);
    }];
    
    //创建网址数组
    NSArray *urlArray = @[@"www.baidu.com",@"www.3g.qq.com",@"www.qiushibaike.com",@"www.sina.cn",@"www.huya.com",@"www.douyu.com",@"www.youku.com",@"www.sohu.com"];
    NSLog(@"%@",urlArray[button.tag]);
    //通过点击获取网址字符串，然后将字符串转换成网址链接
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",urlArray[button.tag]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}
//- (void)backButtonAction {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//- (void)backLastVC {
//    [self.navigationController popViewControllerAnimated:YES];
//}
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
