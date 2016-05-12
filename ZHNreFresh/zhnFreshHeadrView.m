//
//  zhnFreshHeadrView.m
//  ZHNreFresh
//
//  Created by zhn on 16/5/12.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "zhnFreshHeadrView.h"

static CGFloat HeaderViewHeight = 90;
static CGFloat hearRolllayerHeight = 30;

@interface zhnFreshHeadrView()<UIScrollViewDelegate>
/**
 *  是否正在刷新
 */
@property (nonatomic,getter = isFreshing) BOOL freshing;
/**
 *  正在刷新时候做的操作
 */
@property (nonatomic,copy) freshingBlock freshingAction;
/**
 *  圆环layer
 */
@property (nonatomic,weak) CAShapeLayer * rollLayer;

@property (nonatomic,weak) CAGradientLayer * gdlayer;
@end

@implementation zhnFreshHeadrView


- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

+ (zhnFreshHeadrView *)freshHeadrWithFrshAction:(freshingBlock)freshAction{
    zhnFreshHeadrView * freshHeader = [[zhnFreshHeadrView alloc]init];
    freshHeader.freshingAction = freshAction;
    return freshHeader;
}

- (void)setNeedFreshScrollview:(UIScrollView *)needFreshScrollview{
    _needFreshScrollview = needFreshScrollview;
    self.frame = CGRectMake(0, -HeaderViewHeight, self.needFreshScrollview.frame.size.width, HeaderViewHeight);
    
    CAShapeLayer * rollLayer = [CAShapeLayer layer];
    rollLayer.frame = CGRectMake((self.needFreshScrollview.frame.size.width - hearRolllayerHeight)/2, (HeaderViewHeight - hearRolllayerHeight)/2, hearRolllayerHeight +5, hearRolllayerHeight+5);
    self.rollLayer = rollLayer;
    self.rollLayer.strokeColor = [UIColor blackColor].CGColor;
    self.rollLayer.fillColor = [UIColor clearColor].CGColor;
    self.rollLayer.lineWidth = 3;
    self.rollLayer.lineCap = @"round";
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(hearRolllayerHeight/2, hearRolllayerHeight/2) radius:hearRolllayerHeight/2 startAngle: - M_PI_2 endAngle:1.1*M_PI clockwise:YES];
    self.rollLayer.path = path.CGPath;
    self.rollLayer.strokeStart = 0;
    self.rollLayer.strokeEnd = 0;
    
    CAGradientLayer * gradientLayer = [[CAGradientLayer alloc]init];
    gradientLayer.frame = CGRectMake(0, 0, self.needFreshScrollview.frame.size.width, HeaderViewHeight);
    [self.layer addSublayer:gradientLayer];
    gradientLayer.colors = @[(id)[UIColor colorWithWhite:0 alpha:1].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.1].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0.3, 0.6);
//    gradientLayer.locations = @[@0.1, @0.7];
    gradientLayer.mask = rollLayer;
    self.gdlayer = gradientLayer;
    
    // kvo
    [self.needFreshScrollview addObserver:self forKeyPath:@"contentOffset" options: NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [needFreshScrollview addSubview:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (![keyPath isEqualToString:@"contentOffset"])return;
    if (self.needFreshScrollview.dragging) {
    
        [self drawRollLayer];
  
    }else{
        if (self.isFreshing){
           //在刷新的情况下不做处理
        } if (!self.isFreshing && self.needFreshScrollview.contentOffset.y < -HeaderViewHeight) {
            // 刷新动画
            [self freshAnimation];
        }
    }
}

- (void)drawRollLayer{

    CGFloat scale =  -self.needFreshScrollview.contentOffset.y / 80;
    
    if (scale < 0) return;
    scale = scale > 1? 1 : scale;
    self.rollLayer.strokeEnd = scale;
    
}

- (void)startFreshing{
    if (!self.isFreshing) {
        [self freshAnimation];
    }

}
- (void)endFreshing{
    if (self.isFreshing) {
        [self endFreshAnimation];
    }
}

- (void)freshAnimation{
   
    // 添加动画
    [self.gdlayer removeAllAnimations];
    CABasicAnimation * rollAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rollAnima.repeatCount = MAXFLOAT;
    rollAnima.duration = 1.5;
    rollAnima.fromValue = [NSNumber numberWithFloat:0.0];
    rollAnima.toValue = [NSNumber numberWithFloat:4 * M_PI];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.9;
    animation.repeatCount = 1;
    animation.values = @[@1,@1.5,@1];
    
    [self.gdlayer addAnimation:animation forKey:@"scale-layer"];
    [self.gdlayer addAnimation:rollAnima forKey:@"roll-layer"];

    
    [UIView animateWithDuration:0.3 animations:^{
        self.needFreshScrollview.contentInset = UIEdgeInsetsMake(HeaderViewHeight, 0, 0, 0);
        [self.needFreshScrollview scrollRectToVisible:CGRectMake(0, -80, self.needFreshScrollview.frame.size.width, self.needFreshScrollview.frame.size.height) animated:NO];
    } completion:^(BOOL finished) {
        self.freshing = YES;
    }];
    if (self.freshingAction) {
        self.freshingAction();
    }
}

- (void)endFreshAnimation{
    // 删除动画
    [self.gdlayer removeAllAnimations];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.needFreshScrollview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        self.freshing = NO;
    }];
}

- (void)dealloc{
    [self.needFreshScrollview removeObserver:self forKeyPath:@"contentOffset"];
}
@end
