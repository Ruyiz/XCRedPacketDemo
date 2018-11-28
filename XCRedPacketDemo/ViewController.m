//
//  ViewController.m
//  XCRedPacketDemo
//
//  Created by Lucas.Xu on 2018/11/28.
//  Copyright © 2018年 Lucas. All rights reserved.
//

#import "ViewController.h"

#define APP_WIDTH [UIScreen mainScreen].bounds.size.width
#define APP_HEIGHT [UIScreen mainScreen].bounds.size.height
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface ViewController ()
//底部颜色较深的红包底
@property (nonatomic ,strong)CAShapeLayer *redLayer;
//上部分的红包口
@property (nonatomic ,strong)CAShapeLayer *lineLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //深色的红包底
    _redLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *pathFang = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 80, APP_WIDTH - 40, APP_HEIGHT - 160) cornerRadius:4];
    _redLayer.path = pathFang.CGPath;
    _redLayer.zPosition = 1;
    [self.view.layer addSublayer:_redLayer];
    
    [_redLayer setFillColor:[UIColor colorWithRed:0.7968 green:0.2186 blue:0.204 alpha:1.0].CGColor];
    
    //浅色红包口
    _lineLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 80, APP_WIDTH-40, APP_HEIGHT-320) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(4, 4)];
    CGPoint startPoint = CGPointMake(20,  APP_HEIGHT-240);
    CGPoint endPoint = CGPointMake(APP_WIDTH-20, APP_HEIGHT-240);
    CGPoint controlPoint = CGPointMake(APP_WIDTH * 0.5, APP_HEIGHT-180);
    //曲线起点
    [path moveToPoint:startPoint];
    //曲线终点和控制基点
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    //曲线部分颜色和阴影
    [_lineLayer setFillColor:[UIColor colorWithRed:0.851 green:0.3216 blue:0.2784 alpha:1.0].CGColor];
    [_lineLayer setStrokeColor:[UIColor colorWithRed:0.9401 green:0.0 blue:0.0247 alpha:0.02].CGColor];
    [_lineLayer setShadowColor:[UIColor blackColor].CGColor];
    [_lineLayer setLineWidth:0.1];
    [_lineLayer setShadowOffset:CGSizeMake(6, 6)];
    [_lineLayer setShadowOpacity:0.2];
    [_lineLayer setShadowOffset:CGSizeMake(1, 1)];
    _lineLayer.path = path.CGPath;
    _lineLayer.zPosition = 1;
    [self.view.layer addSublayer:_lineLayer];
    
    
    //发红包按钮
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake((APP_WIDTH-100)/2, APP_HEIGHT-240-20, 100, 100)];
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = sendBtn.bounds.size.height/2;
    [sendBtn setTitle:@"開" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:40];
    [sendBtn addTarget:self action:@selector(moveAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setBackgroundColor:RGBACOLOR(224, 187, 130, 1)];
    sendBtn.layer.zPosition = 3;
    [self.view addSubview:sendBtn];
    
    
}

- (void)moveAnimation:(UIButton *)sender{
    //Y方向的动画旋转
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    //    transformAnima.fromValue = @(M_PI_2);
    //旋转到什么角度
    transformAnima.toValue = [NSNumber numberWithFloat: M_PI];
    //旋转一次所需要的时间
    transformAnima.duration = 0.5;
    transformAnima.cumulative = YES;
    transformAnima.autoreverses = NO;
    transformAnima.repeatCount = HUGE_VALF;
    transformAnima.fillMode = kCAFillModeForwards;
    transformAnima.removedOnCompletion = NO;
    transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    sender.layer.zPosition = 5;
    sender.layer.zPosition = sender.layer.frame.size.width/2.f;
    [sender.layer addAnimation:transformAnima forKey:@"rotationAnimationY"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender removeFromSuperview];
        
        UIBezierPath *newPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 80, APP_WIDTH-40, APP_HEIGHT-620) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(4, 4)];
        CGPoint startPoint = CGPointMake(20,  APP_HEIGHT-540);
        CGPoint endPoint = CGPointMake(APP_WIDTH-20, APP_HEIGHT-540);
        CGPoint controlPoint = CGPointMake(APP_WIDTH*0.5, APP_HEIGHT-480);
        //曲线起点
        [newPath moveToPoint:startPoint];
        //曲线终点和控制基点
        [newPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
        
        CGRect newFrame = CGRectMake(20, 80, APP_WIDTH-40, APP_HEIGHT-620);
        
        CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
        pathAnim.toValue = (id)newPath.CGPath;
        
        CABasicAnimation* boundsAnim = [CABasicAnimation animationWithKeyPath: @"frame"];
        boundsAnim.toValue = [NSValue valueWithCGRect:newFrame];
        
        CAAnimationGroup *anims = [CAAnimationGroup animation];
        anims.animations = [NSArray arrayWithObjects:pathAnim, boundsAnim, nil];
        anims.removedOnCompletion = NO;
        anims.duration = 0.1f;
        anims.fillMode  = kCAFillModeForwards;
        [self.lineLayer addAnimation:anims forKey:nil];
    });
    
    
}





@end

