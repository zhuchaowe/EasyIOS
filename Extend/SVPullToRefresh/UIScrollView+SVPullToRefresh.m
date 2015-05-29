//
// UIScrollView+SVPullToRefresh.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+SVPullToRefresh.h"
#import "PullHeader.h"



@interface SVPullToRefreshView ()

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);
@property (nonatomic, readwrite) SVPullToRefreshState state;
@property (nonatomic, assign) BOOL showsPullToRefresh;

@end

#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (SVPullToRefresh)

@dynamic pullToRefreshView, showsPullToRefresh;

-(void)initPullToRefreshWithActionHandler:(void (^)(void))actionHandler{
    
    if(!self.pullToRefreshView) {
        SVPullToRefreshView *view = [[SVPullToRefreshView alloc] init];
        view.pullToRefreshActionHandler = actionHandler;
        view.originalTopInset = self.contentInset.top;
        view.originalBottomInset = self.contentInset.bottom;
        self.pullToRefreshView = view;
        self.showsPullToRefresh = NO;
        
        @weakify(self);
        [[RACObserve(self, contentOffset) filter:^BOOL(id value) {
            @strongify(self);
            return self.showsPullToRefresh;
        }] subscribeNext:^(id x) {
            @strongify(self);
            if(view.state != SVPullToRefreshStateLoading) {
                CGFloat pullNum = self.contentOffset.y + view.originalTopInset;
                if(!self.isDragging && view.state == SVPullToRefreshStateTriggered){
                    view.state = SVPullToRefreshStateLoading;
                }else if(self.isDragging && pullNum < -SVPullToRefreshViewHeight  && view.state == SVPullToRefreshStatePulling)
                    view.state = SVPullToRefreshStateTriggered;
                else if(pullNum <= -1 && pullNum > -SVPullToRefreshViewHeight){
                    view.state = SVPullToRefreshStatePulling;
                }else if(pullNum> -1){
                    view.state = SVPullToRefreshStateStopped;
                }
            }
        }];
        
        [[RACObserve(self, contentSize) filter:^BOOL(id value) {
            @strongify(self);
            return self.contentSize.width >0;
        }] subscribeNext:^(id x) {
            @strongify(self);
            self.showsPullToRefresh = YES;
        }];
    }
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler customer:(BOOL)customer{
    [self initPullToRefreshWithActionHandler:actionHandler];
    if(self.pullToRefreshView) {
        [self addSubview:self.pullToRefreshView];
    }
    if (customer == NO) {
        PullHeader *header = [[PullHeader alloc]initWithScrollView:self];
        [self.pullToRefreshView setCustomView:header];
    }
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler{
    [self addPullToRefreshWithActionHandler:actionHandler customer:NO];
}

- (void)triggerPullToRefresh {
    self.pullToRefreshView.state = SVPullToRefreshStateTriggered;
    [self.pullToRefreshView startAnimating];
}

-(CGFloat)MoveYForPullToRefresh{
    return fabsf(self.contentOffset.y + self.pullToRefreshView.originalTopInset);
}

- (void)setPullToRefreshView:(SVPullToRefreshView *)pullToRefreshView {
    [self willChangeValueForKey:@"SVPullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"SVPullToRefreshView"];
}

- (SVPullToRefreshView *)pullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh {
    self.pullToRefreshView.hidden = !showsPullToRefresh;
}

- (BOOL)showsPullToRefresh {
    return !self.pullToRefreshView.hidden;
}

@end

#pragma mark - SVPullToRefresh
@implementation SVPullToRefreshView

// public properties
@synthesize pullToRefreshActionHandler;
@synthesize state = _state;
@synthesize showsPullToRefresh = _showsPullToRefresh;


- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = SVPullToRefreshStateStopped;
    }
    
    return self;
}

#pragma mark - Getters
- (void)setCustomView:(UIView *)customView{
    
    if (customView && [customView isKindOfClass:[UIView class]]) {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        [self addSubview:customView];
        CGRect viewBounds = [customView bounds];
        CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
        [customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
    }
}

#pragma mark -

- (void)startAnimating{
    self.state = SVPullToRefreshStateLoading;
}

- (void)stopAnimating {
    self.state = SVPullToRefreshStateStopped;
}

- (void)setState:(SVPullToRefreshState)newState {
    
    if(_state == newState) return;
    SVPullToRefreshState previousState = _state;
    _state = newState;
    
    if(newState == SVPullToRefreshStateLoading && previousState == SVPullToRefreshStateTriggered && pullToRefreshActionHandler){
        pullToRefreshActionHandler();
    }
}

@end
