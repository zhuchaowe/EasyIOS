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

@property (nonatomic, strong) NSMutableArray *viewForState;
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
                if(!self.isDragging && view.state == SVPullToRefreshStateTriggered)
                    view.state = SVPullToRefreshStateLoading;
                else if(self.isDragging && pullNum < -SVPullToRefreshViewHeight  && view.state == SVPullToRefreshStatePulling)
                    view.state = SVPullToRefreshStateTriggered;
                else if(pullNum <= 0 && pullNum > -SVPullToRefreshViewHeight){
                    view.state = SVPullToRefreshStatePulling;
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
        PullHeader *header = [[PullHeader alloc]initWithFrame:CGRectMake(0, 0, self.width, SVPullToRefreshViewHeight) with:self];
        [self.pullToRefreshView setCustomView:header forState:SVPullToRefreshStateAll];
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
        self.viewForState = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
    }
    
    return self;
}



#pragma mark - Getters

- (void)setCustomView:(UIView *)view forState:(SVPullToRefreshState)state {
    id viewPlaceholder = view;
    
    if(!viewPlaceholder)
        viewPlaceholder = @"";
    
    if(state == SVPullToRefreshStateAll)
        [self.viewForState replaceObjectsInRange:NSMakeRange(0, 4) withObjectsFromArray:@[viewPlaceholder, viewPlaceholder, viewPlaceholder,viewPlaceholder]];
    else
        [self.viewForState replaceObjectAtIndex:state withObject:viewPlaceholder];
}

#pragma mark -

- (void)startAnimating{
    self.state = SVPullToRefreshStateLoading;
}

- (void)stopAnimating {
    self.state = SVPullToRefreshStateStopped;
}

- (void)setState:(SVPullToRefreshState)newState {
    
    if(_state == newState)
        return;
    
    SVPullToRefreshState previousState = _state;
    _state = newState;
    
    if(newState == SVPullToRefreshStateLoading && previousState == SVPullToRefreshStateTriggered && pullToRefreshActionHandler)
        pullToRefreshActionHandler();

    for(id otherView in self.viewForState) {
        if([otherView isKindOfClass:[UIView class]])
            [otherView removeFromSuperview];
    }
    
    id customView = [self.viewForState objectAtIndex:self.state];
    if (customView && [customView isKindOfClass:[UIView class]]) {
        [self addSubview:customView];
        CGRect viewBounds = [customView bounds];
        CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
        [customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
    }
}

@end
