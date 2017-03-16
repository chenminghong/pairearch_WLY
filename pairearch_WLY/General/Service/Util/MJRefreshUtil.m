//
//  MJRefreshUtil.m
//  iFuWoiPhone
//
//  Created by arvin on 16/7/27.
//  Copyright © 2016年 fuwo. All rights reserved.
//

#import "MJRefreshUtil.h"

#import "MJRefresh.h"

@implementation MJRefreshUtil

+ (void)pullDownRefresh:(id)target andScrollView:(UIScrollView *)scrollView andAction:(SEL)action {
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    header.arrowView.image = [UIImage imageNamed:@"arrow"];
    scrollView.mj_header = header;
}

+ (void)pullUpRefresh:(id)target andScrollView:(UIScrollView *)scrollView andAction:(SEL)action {
    //上拉加载更多
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    footer.stateLabel.hidden = YES;
    footer.arrowView.image = [UIImage imageNamed:@"arrow"];
    scrollView.mj_footer = footer;
}

+ (void)pullRefresh:(id)target andScrollView:(UIScrollView *)scrollView andDownAction:(SEL)downAction andUpAction:(SEL)upAction {
    [MJRefreshUtil pullDownRefresh:target andScrollView:scrollView andAction:downAction];
    [MJRefreshUtil pullUpRefresh:target andScrollView:scrollView andAction:upAction];
}

+ (void)begainRefresh:(UIScrollView *)scrollView {
    [scrollView.mj_header beginRefreshing];
}

+ (void)endRefresh:(UIScrollView *)scrollView {
    [scrollView.mj_header endRefreshing];
    [scrollView.mj_footer endRefreshing];
}

@end
