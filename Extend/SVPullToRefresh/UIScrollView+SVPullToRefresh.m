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

//fequal() and fequalzro() from http://stackoverflow.com/a/1614761/184130
#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)



@interface SVPullToRefreshView ()

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);

@property (nonatomic, readwrite) SVPullToRefreshState state;

@property (nonatomic, strong) NSMutableArray *viewForState;

@property (nonatomic, weak) UIScrollView *scrollView;


@property (nonatomic, assign) BOOL showsPullToRefresh;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForLoading;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;
@end

#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (SVPullToRefresh)

@dynamic pullToRefreshView, showsPullToRefresh;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    
    if(!self.pullToRefreshView) {
        
        SVPullToRefreshView *view = [[SVPullToRefreshView alloc] init];
        view.pullToRefreshActionHandler = actionHandler;
        view.scrollView = self;
        [self addSubview:view];
        
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
            if(self.pullToRefreshView.state != SVPullToRefreshStateLoading) {
                
                CGFloat pullNum = self.contentOffset.y + self.pullToRefreshView.originalTopInset;
                if(!self.isDragging && self.pullToRefreshView.state == SVPullToRefreshStateTriggered)
                    self.pullToRefreshView.state = SVPullToRefreshStateLoading;
                else if(!self.isDragging && pullNum < -SVPullToRefreshViewHeight  && self.pullToRefreshView.state == SVPullToRefreshStatePulling)
                    self.pullToRefreshView.state = SVPullToRefreshStateTriggered;
                else if(pullNum < 0 && pullNum > -SVPullToRefreshViewHeight){
                    self.pullToRefreshView.state = SVPullToRefreshStatePulling;
                }
            }
        }];
        
        
        [[RACObserve(self, contentSize) filter:^BOOL(id value) {
            @strongify(self);
            return self.contentSize.width >0;
        }] subscribeNext:^(id x) {
            @strongify(self);
            CGFloat yOrigin =0;
            if (self.pullToRefreshView.alignToInset) {
                yOrigin = - SVPullToRefreshViewHeight;
            }else{
                yOrigin = - self.pullToRefreshView.originalTopInset -SVPullToRefreshViewHeight;
            }
            self.pullToRefreshView.frame = CGRectMake(0, yOrigin, self.bounds.size.width, SVPullToRefreshViewHeight);
            self.showsPullToRefresh = YES;
        }];
    }
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
@synthesize scrollView = _scrollView;
@synthesize showsPullToRefresh = _showsPullToRefresh;


- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = SVPullToRefreshStateStopped;
        self.alignToInset = YES;
        self.viewForState = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
    }
    
    return self;
}


#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForLoading {
    CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = MIN(offset, self.originalTopInset + self.bounds.size.height);
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:NULL];
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
    
    [self setNeedsLayout];
}

#pragma mark -

- (void)startAnimating{
    if(fequalzero(self.scrollView.contentOffset.y + self.originalTopInset)) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y-self.frame.size.height) animated:YES];
    }
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
    
    switch (newState) {
        case SVPullToRefreshStateStopped:
            [self resetScrollViewContentInset];
            break;
        case SVPullToRefreshStateTriggered:
            break;
        case SVPullToRefreshStateLoading:
            [self setScrollViewContentInsetForLoading];
            if(previousState == SVPullToRefreshStateTriggered && pullToRefreshActionHandler)
                pullToRefreshActionHandler();
            break;
        default:
            break;
    }
    
    
    for(id otherView in self.viewForState) {
        if([otherView isKindOfClass:[UIView class]])
            [otherView removeFromSuperview];
    }
    
    id customView = [self.viewForState objectAtIndex:self.state];
    if (customView) {
        [self addSubview:customView];
        CGRect viewBounds = [customView bounds];
        CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
        [customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
    }
}

@end
