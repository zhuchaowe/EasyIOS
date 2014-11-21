//
// UIScrollView+SVPullToRefresh.h
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

static CGFloat const SVPullToRefreshViewHeight = 60;

@class SVPullToRefreshView;

@interface UIScrollView (SVPullToRefresh)

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)triggerPullToRefresh;
- (CGFloat)MoveYForPullToRefresh;
@property (nonatomic, strong, readonly) SVPullToRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL showsPullToRefresh;

@end

typedef NS_ENUM(NSUInteger, SVPullToRefreshState) {
    SVPullToRefreshStateStopped = 0,
    SVPullToRefreshStateTriggered,
    SVPullToRefreshStateLoading,
    SVPullToRefreshStatePulling,
    SVPullToRefreshStateAll = 10
};
@interface SVPullToRefreshView : UIView

@property (nonatomic, assign) BOOL alignToInset;
@property (nonatomic, readonly) SVPullToRefreshState state;
@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic, readwrite) CGFloat originalBottomInset;
- (void)setCustomView:(UIView *)view forState:(SVPullToRefreshState)state;
- (void)startAnimating;
- (void)stopAnimating;

@end
