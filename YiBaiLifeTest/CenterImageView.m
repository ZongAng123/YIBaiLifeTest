//
//  CenterImageView.m
//  YiBaiLifeTest
//
//  Created by Earl on 16/7/9.
//  Copyright (c) 2016年 Earl. All rights reserved.
//

#import "CenterImageView.h"

//定义宏 屏幕宽度和高度

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
//延展，扩展
@interface CenterImageView ()
//声明一个太阳或月亮的视图
@property (nonatomic, strong)UIImageView *sunOrMoonView;
//声明太阳照片数组
@property (nonatomic, strong)NSArray *sunArray;
//声明月亮照片数组
@property (nonatomic, strong)NSArray *moonArray;
//声明一个星星帧动画视图数组
@property (nonatomic, strong)NSMutableArray *starArray;
//声明一个雨滴视图数组
@property (nonatomic, strong)NSMutableArray *rainArray;
//声明一个云朵视图数组
@property (nonatomic, strong)NSMutableArray *cloudArray;
//声明雨滴和云朵定时器，为了寻找可以移动的视图
@property (nonatomic, strong)NSTimer *rainTimer;
@property (nonatomic, strong)NSTimer *cloudTimer;


@end

@implementation CenterImageView


#pragma mark - 懒加载 加载数组或视图资源
//星星数组懒加载
- (NSMutableArray *)starArray {
    if (!_starArray) {
        self.starArray = [NSMutableArray array];
        for (int i = 0; i < 50; i++) {
            UIImageView *starView = [[UIImageView alloc] initWithFrame:CGRectMake(arc4random() % (int)kScreenWidth - 20, arc4random() % 100, 20, 20)];
            starView.animationDuration = 0.5;
            starView.animationImages = @[[UIImage imageNamed:@"xx1"],[UIImage imageNamed:@"xx2"]];
            [self addSubview:starView];
            [_starArray addObject:starView];
        }
    }
    return _starArray;
}
//雨滴视图数组懒加载
- (NSMutableArray *)rainArray {
    if (!_rainArray) {
        self.rainArray = [NSMutableArray array];
        for (int i = 0; i < 50; i++) {
            UIImageView *rainView = [[UIImageView alloc] initWithFrame:CGRectMake(arc4random() % (int)kScreenWidth - 10, -10, 10, 10)];
            rainView.image = [UIImage imageNamed:@"w_rain"];
            //用tag值来标记雨滴的初始状态
            rainView.tag = 100;
            [self addSubview:rainView];
            [_rainArray addObject:rainView];
        }
    }
    return _rainArray;
}
//云朵视图懒加载
- (NSMutableArray *)cloudArray {
    if (!_cloudArray) {
        self.cloudArray = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            UIImageView *cloudView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth + 50, arc4random() % 100, 118, 57.5)];
            cloudView.image = [UIImage imageNamed:@"w_cloud"];
            //用tag值标记初始状态
            cloudView.tag = 200;
            [self addSubview:cloudView];
            [_cloudArray addObject:cloudView];
        }
    }
    return _cloudArray;
}
//重写父类的初始化方法，为了初始化自己的控件

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        self.sunOrMoonView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 50, 150, 150)];
        //设置帧动画的时间
        _sunOrMoonView.animationDuration = 0.5;
        [self addSubview:self.sunOrMoonView];
        //太阳图片数组
        self.sunArray = @[[UIImage imageNamed:@"w_sun1"],[UIImage imageNamed:@"w_sun2"]];
        //月亮图片数组
        self.moonArray = @[[UIImage imageNamed:@"w_moon1"],[UIImage imageNamed:@"w_moon2"]];
        //默认为周一显示的是太阳
        [self isOrNeedSunAndMoon:YES andIsOrNight:NO];
        
    }
    return self;
}

#pragma mark - 判断是否出太阳和月亮，并判断是白天还是黑夜，从而判断出的是太阳还是月亮

- (void)isOrNeedSunAndMoon:(BOOL)isNeed andIsOrNight:(BOOL)isNight {
    if (isNeed == YES) {
        //如果需要太阳或月亮动画，那么继续判断，出月亮还是出太阳
        if (isNight == YES) {
            //如果是夜晚，则将月亮数组赋值给帧动画视图的图片数组属性
            self.sunOrMoonView.animationImages = self.moonArray;
        }else {
            //如果不是则是太阳
           self.sunOrMoonView.animationImages = self.sunArray;
        }
        //让帧动画开始
        [self.sunOrMoonView startAnimating];
        
    }else {
        //如果不需要就让帧动画停止
        [self.sunOrMoonView stopAnimating];
        
        
    }
}
#pragma mark - 判断是否需要星星
- (void)isOrNeedStar:(BOOL)need {
    if (need == YES) {
       //需要星星
        //如果需要星星，则让所有的星星开始帧动画，如果不需要，让所有的星星停止帧动画
        for (UIImageView *starView in self.starArray) {
            [starView startAnimating];
        }
    }else {
        //不需要星星
        for (UIImageView *starView in self.starArray) {
            [starView stopAnimating];
        }
    }
}
#pragma mark - 判断是否需要雨滴
- (void)isOrNeedRain:(BOOL)need {
    //当需要雨滴时，就开启定时器，让雨滴下落，开启定时器的时候，还要判断定时器是否为空，为了解决重复点击同一个按钮创建生成多个定时器的问题
    if (need == YES) {
        if (self.rainTimer == nil) {
             self.rainTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(rainTimerAction) userInfo:nil repeats:YES];
        }
    }else {
        [self.rainTimer invalidate];
        self.rainTimer = nil;
        //当定时器销毁的时候，设置全部雨滴都回到起始位置状态
        for (UIImageView *rainView in self.rainArray) {
            rainView.center = CGPointMake(arc4random() % (int)kScreenWidth - 10, -10);
            rainView.tag = 100;
        }
    }
}
- (void)rainTimerAction {
    for (UIImageView *rainView in self.rainArray) {
        if (rainView.tag == 100) {
            rainView.tag = 101;
            [UIView animateWithDuration:2 animations:^{
                rainView.center = CGPointMake(rainView.center.x, kScreenHeight);
            } completion:^(BOOL finished) {
                //当动画执行结束之后，要回到初始位置以及状态
                rainView.tag = 100;
                rainView.center = CGPointMake(arc4random() % (int)kScreenWidth - 10, -10);
            }];
            break;//找到一个就结束
        }
    }
}
#pragma mark - 判断是否需要云朵
- (void)isOrNeedCloud:(BOOL)need {
    //当需要云朵时，就开启定时器，让云朵飘落，开启定时器的时候，还要判断定时器是否为空，为了解决重复点击同一个按钮创建生成多个定时器的问题
    if (need == YES) {
        if (self.cloudTimer == nil) {
            self.cloudTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(cloudTimerAction) userInfo:nil repeats:YES];
        }
    }else {
        [self.cloudTimer invalidate];
        self.cloudTimer = nil;
        for (UIImageView *cloudView in self.cloudArray) {
            cloudView.tag = 200;
            cloudView.center = CGPointMake(kScreenWidth + 100, arc4random() % 100);
        }
    }
}
- (void)cloudTimerAction {
    for (UIImageView *cloudView in self.cloudArray) {
        if (cloudView.tag == 200) {
            cloudView.tag = 201;
            [UIView animateWithDuration:5 animations:^{
                cloudView.center = CGPointMake(-100, cloudView.center.y);
            } completion:^(BOOL finished) {
                //动画结束之后，修改为初始状态
                cloudView.tag = 200;
                cloudView.center = CGPointMake(kScreenWidth + 100, arc4random() % 100);
            }];
            break;//找到一个就结束
        }
    }
}
- (void)changeWeatherWithIsOrNight:(BOOL)isNight andWeekButtonTag:(NSInteger)tag {
    if (isNight == YES) {
        //夜晚
        //如果是夜晚，要修改为夜晚的背景图
        self.image = [UIImage imageNamed:@"w_night"];
        //周一,五,六,日
        if (tag == 0 || tag == 4 || tag == 5 || tag == 6) {
            [self isOrNeedStar:YES];
            [self isOrNeedRain:NO];
            [self isOrNeedCloud:NO];
            [self isOrNeedSunAndMoon:YES andIsOrNight:isNight];
        }
        //周二：
        if (tag == 1) {
            [self isOrNeedStar:YES];
            [self isOrNeedRain:NO];
            [self isOrNeedCloud:YES];
            [self isOrNeedSunAndMoon:YES andIsOrNight:isNight];
        }
        //周三：
        if (tag == 2) {
            [self isOrNeedStar:NO];
            [self isOrNeedRain:NO];
            [self isOrNeedCloud:NO];
            [self isOrNeedSunAndMoon:NO andIsOrNight:isNight];
        }
        //周四：
        if (tag == 3) {
            [self isOrNeedStar:NO];
            [self isOrNeedRain:YES];
            [self isOrNeedCloud:NO];
            [self isOrNeedSunAndMoon:NO andIsOrNight:isNight];
        }
    }else {
        
        //白天
        //周一,五,六,日
        if (tag == 0 || tag == 4 || tag == 5 || tag == 6) {
            self.image = [UIImage imageNamed:@"w_qing"];
            [self isOrNeedStar:NO];
            [self isOrNeedRain:NO];
            [self isOrNeedCloud:NO];
            [self isOrNeedSunAndMoon:YES andIsOrNight:isNight];
        }
        //周二：
        if (tag == 1) {
            self.image = [UIImage imageNamed:@"w_duoyun"];
            [self isOrNeedStar:NO];
            [self isOrNeedRain:NO];
            [self isOrNeedCloud:YES];
            [self isOrNeedSunAndMoon:YES andIsOrNight:isNight];
        }
        //周三：
        if (tag == 2) {
            self.image = [UIImage imageNamed:@"w_yin"];
            [self isOrNeedStar:NO];
            [self isOrNeedRain:NO];
            [self isOrNeedCloud:NO];
            [self isOrNeedSunAndMoon:NO andIsOrNight:isNight];
        }
        //周四：
        if (tag == 3) {
            self.image = [UIImage imageNamed:@"w_yu"];
            [self isOrNeedStar:NO];
            [self isOrNeedRain:YES];
            [self isOrNeedCloud:NO];
            [self isOrNeedSunAndMoon:NO andIsOrNight:isNight];
        }

        
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
