//
// UIScrollView+SVInfiniteScrolling.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+SVInfiniteScrolling.h"
#import "PullFooter.h"



@interface SVInfiniteScrollingView ()

@property (nonatomic, copy) void (^infiniteScrollingHandler)(void);

@property (nonatomic, readwrite) SVInfiniteScrollingState state;
@property (nonatomic, strong) NSMutableArray *viewForState;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalBottomInset;
@property (nonatomic, assign) BOOL wasTriggeredByUser;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForInfiniteScrolling;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;

@end

#pragma mark - UIScrollView (SVInfiniteScrollingView)
#import <objc/runtime.h>

static char UIScrollViewInfiniteScrollingView;
UIEdgeInsets scrollViewOriginalContentInsets;

@implementation UIScrollView (SVInfiniteScrolling)

@dynamic infiniteScrollingView;

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler customer:(BOOL)customer{

    if(!self.infiniteScrollingView) {
        SVInfiniteScrollingView *view = [[SVInfiniteScrollingView alloc] init];
        view.infiniteScrollingHandler = actionHandler;
        view.scrollView = self;
        [self addSubview:view];
        
        view.originalBottomInset = self.contentInset.bottom;
        self.infiniteScrollingView = view;
        self.showsInfiniteScrolling = NO;
        @weakify(self);
        [[RACObserve(self, contentOffset) filter:^BOOL(id value) {
            @strongify(self);
            return self.showsInfiniteScrolling;
        }] subscribeNext:^(id x) {
             @strongify(self);
            if(self.infiniteScrollingView.state != SVInfiniteScrollingStateLoading && self.infiniteScrollingView.state !=SVInfiniteScrollingStateEnded && self.infiniteScrollingView.enabled && self.contentSize.height >0) {
                CGFloat scrollViewContentHeight = self.contentSize.height;
                CGFloat scrollOffsetThreshold = scrollViewContentHeight - self.bounds.size.height + self.infiniteScrollingView.extendBottom;
                if(!self.isDragging && self.infiniteScrollingView.state == SVInfiniteScrollingStateTriggered)
                    self.infiniteScrollingView.state = SVInfiniteScrollingStateLoading;
                else if(self.isDragging && self.infiniteScrollingView.state == SVInfiniteScrollingStatePulling && self.contentOffset.y - scrollOffsetThreshold > SVInfiniteScrollingViewHeight)
                    self.infiniteScrollingView.state = SVInfiniteScrollingStateTriggered;
                else if(self.contentOffset.y - scrollOffsetThreshold >0 && self.contentOffset.y - scrollOffsetThreshold<SVInfiniteScrollingViewHeight )
                    self.infiniteScrollingView.state = SVInfiniteScrollingStatePulling;
                else if(self.contentOffset.y < scrollOffsetThreshold && self.infiniteScrollingView.state != SVInfiniteScrollingStateStopped)
                    self.infiniteScrollingView.state = SVInfiniteScrollingStateStopped;
            }
        }];
        
        [[RACObserve(self, contentSize) filter:^BOOL(id value) {
            @strongify(self);
            return self.contentSize.height>=self.bounds.size.height;
        }] subscribeNext:^(id x) {
            @strongify(self);
            self.showsInfiniteScrolling = YES;
            self.infiniteScrollingView.frame = CGRectMake(0, self.contentSize.height, self.bounds.size.width, SVInfiniteScrollingViewHeight);
        }];
    }
    
    if (customer == NO) {
        PullFooter *infiniteView = [[PullFooter alloc] initWithFrame:CGRectMake(0, 0, self.width, SVInfiniteScrollingViewHeight)  with:self];
        [self.infiniteScrollingView setCustomView:infiniteView forState:SVInfiniteScrollingStateAll];
    }
}

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler{
    [self addInfiniteScrollingWithActionHandler:actionHandler customer:NO];
}

- (void)triggerInfiniteScrolling {
    self.infiniteScrollingView.state = SVInfiniteScrollingStateTriggered;
    [self.infiniteScrollingView startAnimating];
}

-(CGFloat)MoveYForInfinite{
    return fabsf(self.contentSize.height - self.bounds.size.height + self.infiniteScrollingView.extendBottom - self.contentOffset.y);
}

- (void)setInfiniteScrollingView:(SVInfiniteScrollingView *)infiniteScrollingView {
    [self willChangeValueForKey:@"UIScrollViewInfiniteScrollingView"];
    objc_setAssociatedObject(self, &UIScrollViewInfiniteScrollingView,
                             infiniteScrollingView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UIScrollViewInfiniteScrollingView"];
}

- (SVInfiniteScrollingView *)infiniteScrollingView {
    return objc_getAssociatedObject(self, &UIScrollViewInfiniteScrollingView);
}

- (void)setShowsInfiniteScrolling:(BOOL)showsInfiniteScrolling {
    self.infiniteScrollingView.hidden = !showsInfiniteScrolling;
}

- (BOOL)showsInfiniteScrolling {
    return !self.infiniteScrollingView.hidden;
}
@end

#pragma mark - SVInfiniteScrollingView
@implementation SVInfiniteScrollingView
@synthesize infiniteScrollingHandler;
@synthesize state = _state;
@synthesize scrollView = _scrollView;

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = SVInfiniteScrollingStateStopped;
        self.enabled = YES;
        self.extendBottom = 0.0f;
        self.viewForState = [NSMutableArray arrayWithObjects:@"", @"", @"", @"",  @"",nil];
    }
    return self;
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    CGFloat newBottom  = self.originalBottomInset + self.extendBottom;
    if (newBottom != currentInsets.bottom) {
        currentInsets.bottom = newBottom;
        [self setScrollViewContentInset:currentInsets];
    }
}

- (void)setScrollViewContentInsetForInfiniteScrolling {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    CGFloat newBottom  = self.originalBottomInset + self.extendBottom + SVInfiniteScrollingViewHeight;
    if (newBottom != currentInsets.bottom) {
        currentInsets.bottom = newBottom;
        [self setScrollViewContentInset:currentInsets];
    }
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

#pragma mark - Setters

- (void)setCustomView:(UIView *)view forState:(SVInfiniteScrollingState)state {
    id viewPlaceholder = view;
    
    if(!viewPlaceholder)
        viewPlaceholder = @"";
    
    if(state == SVInfiniteScrollingStateAll)
        [self.viewForState replaceObjectsInRange:NSMakeRange(0, 4) withObjectsFromArray:@[viewPlaceholder, viewPlaceholder, viewPlaceholder,viewPlaceholder,viewPlaceholder]];
    else
        [self.viewForState replaceObjectAtIndex:state withObject:viewPlaceholder];
}


#pragma mark -

- (void)startAnimating{
    self.state = SVInfiniteScrollingStateLoading;
}

- (void)stopAnimating {
    self.state = SVInfiniteScrollingStateStopped;
}

- (void)setEnded{
    self.state = SVInfiniteScrollingStateEnded;
}

- (void)setState:(SVInfiniteScrollingState)newState {
    if(_state == newState)
        return;
    
    SVInfiniteScrollingState previousState = _state;
    _state = newState;
    
    
    switch (newState) {
        case SVInfiniteScrollingStateEnded:
        case SVInfiniteScrollingStateStopped:
            [self resetScrollViewContentInset];
            break;
        case SVPullToRefreshStateTriggered:
            break;
        case SVInfiniteScrollingStateLoading:
             [self setScrollViewContentInsetForInfiniteScrolling];
            if(previousState == SVInfiniteScrollingStateTriggered && self.infiniteScrollingHandler && self.enabled)
                self.infiniteScrollingHandler();
            break;
        default:
            break;
    }
    
    
    for(id otherView in self.viewForState) {
        if([otherView isKindOfClass:[UIView class]])
            [otherView removeFromSuperview];
    }
    
    id customView = [self.viewForState objectAtIndex:newState];
    if (customView && [customView isKindOfClass:[UIView class]]) {
        [self addSubview:customView];
        CGRect viewBounds = [customView bounds];
        CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
        [customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
    }

}
@end
