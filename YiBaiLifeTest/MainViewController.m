//
//  MainViewController.m
//  YiBaiLifeTest
//
//  Created by Earl on 16/7/5.
//  Copyright (c) 2016年 Earl. All rights reserved.
//

#import "MainViewController.h"
#import "MainButton.h"

#define kScreenCenterX self.view.center.x
#define kScreenCenterY self.view.center.y
#define kRandio 100


@interface MainViewController (){
    int a;
}
//声明一个数组，存放所有的button，后面要遍历，修改button的角度
@property (nonatomic, strong)NSMutableArray *buttonArray;
//声明一个定时器属性，让button的角度增加
@property (nonatomic, strong)NSTimer *timer;
//用来标记或接受选中的按钮
@property (nonatomic, strong)MainButton *selectedButton;
@end

@implementation MainViewController

//button数组的懒加载
//重写get方法，将对象的创建封装在里面
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        self.buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建背景视图
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgView.image = [UIImage imageNamed:@"bg2.jpg"];
    [self.view addSubview:bgView];
    
    
    //通过for循环创建4个button
    for (int i = 0; i < 4; i++) {
        MainButton *button = [MainButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 50, 50);
        //设置button视图的角度
        button.angle = i * 90;
        //修改中心点
        button.center = CGPointMake(kScreenCenterX + kRandio * cos(button.angle * M_PI / 180), kScreenCenterY + kRandio * sin(button.angle * M_PI / 180));
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"m_item%d",i + 1]] forState:UIControlStateNormal];
        //设置button的tag值
        button.tag = i;
        //添加绑定方法
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        //将创建的button添加在数组中
        [self.buttonArray addObject:button];
    }
    
}
- (void)buttonAction:(MainButton *)button {
    //记录点击的button（将button赋值给selectedButton）
    self.selectedButton = button;
    //判断定时器为空时，证明上一个定时器已经销毁失效，这个时候才去创建下一个定时器，否则，会创建多个定时器，导致出错
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
}
- (void)timerAction {
    //判断点击的button的角度，如果在最上方，就让定时器停止，并且进入详情页面
    if (self.selectedButton.angle % 360 == 270) {
        //定时器销毁
        [self.timer invalidate];
        //定时器置空
        self.timer = nil;
        
        //执行进入详情页面的方法
        [self goToDetailViewController];
        
    }else {
        
        //第一种
//        for (int i = 0; i < self.buttonArray.count; i++) {
//            MainButton *button = self.buttonArray[i];
//        }
        //第二种
        //使用forin遍历数组，来修改数组中所有button的角度，从而达到修改button的位置，让其转动
        for (MainButton *button in self.buttonArray) {
            //让角度增加
            button.angle ++;
            //重新修改中心点
           button.center = CGPointMake(kScreenCenterX + kRandio * cos(button.angle * M_PI / 180), kScreenCenterY + kRandio * sin(button.angle * M_PI / 180));
        }
        
        
    }
}
- (void)goToDetailViewController {
   //第一种 用if判断
    //第二种 switch...case
//    UIViewController *VC = nil;
//    
//    switch (self.selectedButton.tag) {
//        case 0:{
//            VC = [[WeatherViewController alloc] init];
//          
//        }
//            break;
//        case 1:{
//            VC = [[SearchViewController alloc] init];
//        }
//            break;
//        case 2:{
//            VC = [[CityViewController alloc] init];
//            
//        }
//            break;
//        case 3:{
//            VC = [[NewsViewController alloc] init];
//        }
//            break;
//        default:
//            break;
//    }
//    [self.navigationController pushViewController:VC animated:YES];
    
    //第三种方式创建
    //将类名的字符串全部放进数组中，点击到哪个button时，通过button的tag值去数组中找到对应的字符串，当找到字符串后，将其转换成类型，通过这个类名调用alloc方法，创建类的对象，然后push
    NSArray *array = @[@"WeatherViewController",@"SearchViewController",@"CityViewController",@"NewsViewController"];
    //获取点中的按钮对应的类名字符串
    NSString *classStr = array[self.selectedButton.tag];
    //NSClassFromString(classStr) 是将字符串转换成类名
    //NSStringFromClass(类型名) 是将类名转换成字符串
    //创建对应的视图控制器对象
    UIViewController *jumpVC = [[NSClassFromString(classStr) alloc] init];
    
    [self.navigationController pushViewController:jumpVC animated:YES];
    
    
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
