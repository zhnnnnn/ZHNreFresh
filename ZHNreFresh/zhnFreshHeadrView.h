//
//  zhnFreshHeadrView.h
//  ZHNreFresh
//
//  Created by zhn on 16/5/12.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^freshingBlock)();
@interface zhnFreshHeadrView : UIView
// 不需要传递父滑动控件
@property (nonatomic,strong) UIScrollView * needFreshScrollview;

/**
 *  构造方法 上传刷新控件
 *
 *  @param freshAction 在刷新的时候做的操作
 *
 *  @return 刷新控件
 */
+ (zhnFreshHeadrView *)freshHeadrWithFrshAction:(freshingBlock)freshAction;

// 开始，结束 刷新
- (void)startFreshing;
- (void)endFreshing;
@end
