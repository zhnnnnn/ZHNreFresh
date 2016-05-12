//
//  UIScrollView+ZHNfresh.m
//  ZHNreFresh
//
//  Created by zhn on 16/5/12.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "UIScrollView+ZHNfresh.h"
#import <objc/runtime.h>
#import "zhnFreshHeadrView.h"

@implementation UIScrollView (ZHNfresh)

- (void)setZhnFreshView:(zhnFreshHeadrView *)zhnFreshView{
    zhnFreshView.needFreshScrollview = self;
    objc_setAssociatedObject(self, @"freshView", zhnFreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (zhnFreshHeadrView *)zhnFreshView{
    return objc_getAssociatedObject(self, @"freshView");
}

@end
