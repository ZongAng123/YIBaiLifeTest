//
//  RootViewController.m
//  YiBaiLifeTest
//
//  Created by Earl on 16/7/5.
//  Copyright (c) 2016年 Earl. All rights reserved.
//

#import "RootViewController.h"
#import "BigImageView.h"
#import "SmallButton.h"
#import "MainViewController.h"
//定义宏 屏幕宽度和高度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface RootViewController ()
//声明一个可变的数组，来存放bigImageView视图，后面要遍历数组，查看每个大图上面的数字和密码button数字是否相等
@property (nonatomic, strong)NSMutableArray *bigViewArray;
//记录button上的数字和大图上的数字一样的个数，如果为4，将让其翻页进入主页面
@property (nonatomic, assign)int rightCount;
@end

@implementation RootViewController
//数组懒加载
- (NSMutableArray *)bigViewArray {
    if (!_bigViewArray) {
        self.bigViewArray = [NSMutableArray array];
    }
    return _bigViewArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)creatUI {
//添加背景图片
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgView.image = [UIImage imageNamed:@"bg.jpg"];
    [self.view addSubview:bgView];
    
    /*
     思路：创建一个数组，存放0~9对应的字符串，声明一个随机数，范围为数组索引的范围：根据随机数（索引），从数组中取出一个字符串，根据这个字符串拼接图片的名称，获取图片；然后删除数组中这个字符串，避免重复
     */
    NSMutableArray *numberArray = [NSMutableArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    //利用for循环创建4个视图并添加在根视图上面
    for (int i = 0; i < 4; i++) {
        
        //计算视图之间的间距
        float bigSpeeX = (kScreenWidth - 55 * 4) / 5;
        
        //创建视图
        BigImageView *bigImageView = [[BigImageView alloc] initWithFrame:CGRectMake(bigSpeeX + i * (55 + bigSpeeX), 150, 55, 55)];
        //先得到4个随机数
        int randomNumber = arc4random() % numberArray.count;
        //根据这个随机数，从数组中取出一个字符串（防止重复）
        NSString *numberStr = numberArray[randomNumber];
        //拼接字符串得到对应的图片对象
        bigImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"b_%@",numberStr]];
        //用tag值来标记imageView上的数字（后面要判断密码是否正确）
        bigImageView.tag = [numberStr intValue];
        [self.view addSubview:bigImageView];
        //把已经取出来的字符串从数组中移除，避免下一次取得时候，出现重复
        [numberArray removeObjectAtIndex:randomNumber];
        //把图片视图添加到数组中
        [self.bigViewArray addObject:bigImageView];
    }
    
    //利用for循环创建下面的button视图
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 5; j++) {
            //计算间距
            float smallSpeedX = (kScreenWidth - 5 * 45) / 6;
            SmallButton *button = [SmallButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(smallSpeedX + j * (45 + smallSpeedX), 300 + i *(45 + smallSpeedX), 45, 45);
            //记录各自button的最初的中心点
            button.downCenter = button.center;
            //记录创建button上的数字
            static int count = 0;
            count ++;
            if (count == 10) {
                count = 0;//当到达第十个的时候，应该为0
            }
            //用各自的tag值来标记自己的数字，在后面判断是否与imageView的tag值相等
            button.tag = count;
            
            //设置背景图片
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"s_%d",count]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            //添加显示
            [self.view addSubview:button];
        }
    }
    
}
- (void)buttonAction:(SmallButton *)button {
    //当点击的button没有在上面
    if (button.isOrUp == NO) {
        //快速遍历上面的4个bigimageView,找到一个未被覆盖的，然后让button上去，
        for (BigImageView *imageView in self.bigViewArray) {
            //当图片视图没有被覆盖的时候，既然能执行进去，那么button一定会上去将其覆盖，所以提前标记imageView已经覆盖，不然的话动画执行会有个时间，快速点击下一个按钮，也会到达同一个图片上面
            if (imageView.isOrCovered == NO) {
                imageView.isOrCovered = YES;
                
                [UIView animateWithDuration:1 animations:^{
                    //挪动button的center上去 加上动画
                    button.center = imageView.center;
                }completion:^(BOOL finished) {
                    //上去之后，标记button在上面
                    button.isOrUp = YES;
                    //button上去的时候，记录下方的imageView，当button下来的时候，要标记其为未被覆盖（容易获取到）
                    button.bottomImageView = imageView;
                    //button上去之后，判断button上的数字和imageView上的数字是否相同，如果相同，让正确的次数+1，然后判断正确的次数是否为4，如果为4，进入主页面
                    if (button.tag == imageView.tag) {
                        self.rightCount ++;
                        if (self.rightCount == 4) {
                            NSLog(@"进入主页面");
                            [self gotoMainView];
                        }
                    }
                }];
                
                break;
            }
        }
        
    }else {
        
    //当点击的button在上面
        //获取被button覆盖的那个bigimageView
        BigImageView *imageView = button.bottomImageView;
        //button下来之后，设置图片视图未被覆盖，同样要提前标注（否则快速点击下一个button，则不会上去，因为属性还修改过来）
        imageView.isOrCovered = NO;
        
        [UIView animateWithDuration:1 animations:^{
            //button回到初始位置中心点
            button.center = button.downCenter;
        } completion:^(BOOL finished) {
            //完成后，设置button没有在上面（在下面）
            button.isOrUp = NO;
            if (button.tag == imageView.tag) {
                //如果下来的button的数字和大图上的数组一样的话，则正确的次数-1
                self.rightCount--;
            }
        }];
    }
}
//密码都正确，进入主页面的方法
- (void)gotoMainView {
    MainViewController *mainVC = [[MainViewController alloc] init];
    
    UINavigationController *naviC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    //隐藏导航条
    naviC.navigationBar.hidden = YES;
    
    //naviC.navigationBarHidden = YES;
    
    
    self.view.layer.cornerRadius = 30;

    
    [UIApplication sharedApplication].delegate.window.rootViewController = naviC;
    //做动画 第一种
    [UIView animateWithDuration:1 animations:^{
        
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[UIApplication sharedApplication].keyWindow cache:YES];
        
    }];
        //第二种
//    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
//        
//    } completion:^(BOOL finished) {
//        
//    }];
    
}
#warning 项目结束后删除
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self gotoMainView];
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
