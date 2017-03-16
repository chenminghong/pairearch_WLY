//
//  MJRefreshUtil.h
//  iFuWoiPhone
//
//  Created by arvin on 16/7/27.
//  Copyright © 2016年 fuwo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJRefreshUtil : NSObject

+ (void)pullDownRefresh:(id)target andScrollView:(UIScrollView *)scrollView andAction:(SEL)action;

+ (void)pullUpRefresh:(id)target andScrollView:(UIScrollView *)scrollView andAction:(SEL)action;

+ (void)pullRefresh:(id)target andScrollView:(UIScrollView *)scrollView andDownAction:(SEL)downAction andUpAction:(SEL)upAction;

+ (void)begainRefresh:(UIScrollView *)scrollView;

+ (void)endRefresh:(UIScrollView *)scrollView;

@end
