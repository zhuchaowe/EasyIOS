//
// UIScrollView+SVInfiniteScrolling.h
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <UIKit/UIKit.h>

static CGFloat const SVInfiniteScrollingViewHeight = 60;

@class SVInfiniteScrollingView;

@interface UIScrollView (SVInfiniteScrolling)

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler customer:(BOOL)customer;
- (void)initInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
- (void)triggerInfiniteScrolling;
- (CGFloat)MoveYForInfinite;
@property (nonatomic, strong, readonly) SVInfiniteScrollingView *infiniteScrollingView;
@property (nonatomic, assign) BOOL showsInfiniteScrolling;

@end


enum {
	SVInfiniteScrollingStateStopped = 0, //停止
    SVInfiniteScrollingStateTriggered, //触发
    SVInfiniteScrollingStateLoading, //loading
    SVInfiniteScrollingStateEnded, //到达底部
    SVInfiniteScrollingStatePulling //下拉中
};

typedef NSUInteger SVInfiniteScrollingState;

@interface SVInfiniteScrollingView : UIView

@property (nonatomic, readonly) SVInfiniteScrollingState state;
@property (nonatomic, readwrite) CGFloat extendBottom;
@property (nonatomic, readwrite) CGFloat originalBottomInset;
@property (nonatomic, readwrite) BOOL enabled;

- (void)setCustomView:(UIView *)view;
- (void)startAnimating;
- (void)stopAnimating;
- (void)setEnded;
- (void)resetState;

@end
