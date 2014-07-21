//
//  MJRefreshConst.m
//  MJRefresh
//
//  Created by mj on 14-1-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//
#import <UIKit/UIKit.h>
const CGFloat MJRefreshViewHeight = 64.0;
const CGFloat MJRefreshAnimationDuration = 0.25;
NSString *const MJRefreshFooterPullToRefresh = @"上拉加载更多"; //上拉加载
NSString *const MJRefreshFooterReleaseToRefresh = @"松开加载更多";//释放加载
NSString *const MJRefreshFooterRefreshing = @"正在加载中";
NSString *const MJRefreshFooterEnd = @"没有更多了";

NSString *const MJRefreshHeaderPullToRefresh = @"下拉可以刷新";  //下拉刷新
NSString *const MJRefreshHeaderReleaseToRefresh = @"松开后刷新"; //释放刷新
NSString *const MJRefreshHeaderRefreshing = @"正在刷新中"; //正在刷新
NSString *const MJRefreshHeaderTimeKey = @"MJRefreshHeaderView";

NSString *const MJRefreshContentOffset = @"contentOffset";
NSString *const MJRefreshContentSize = @"contentSize";