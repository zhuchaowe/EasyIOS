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
@property (nonatomic, assign) BOOL wasTriggeredByUser;

@end

#pragma mark - UIScrollView (SVInfiniteScrollingView)
#import <objc/runtime.h>

static char UIScrollViewInfiniteScrollingView;
UIEdgeInsets scrollViewOriginalContentInsets;

@implementation UIScrollView (SVInfiniteScrolling)

@dynamic infiniteScrollingView;

- (void)initInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler{
    if(!self.infiniteScrollingView) {
        SVInfiniteScrollingView *view = [[SVInfiniteScrollingView alloc] init];
        view.infiniteScrollingHandler = actionHandler;
        view.originalBottomInset = self.contentInset.bottom;
        self.infiniteScrollingView = view;
        self.showsInfiniteScrolling = NO;
        
        
        @weakify(self);
        [[RACObserve(self, contentOffset) filter:^BOOL(id value) {
            @strongify(self);
            return self.showsInfiniteScrolling;
        }] subscribeNext:^(id x) {
            @strongify(self);
            if(view.state != SVInfiniteScrollingStateLoading && view.state !=SVInfiniteScrollingStateEnded && view.enabled && self.contentSize.height >0) {
                CGFloat scrollViewContentHeight = self.contentSize.height;
                CGFloat scrollOffsetThreshold = scrollViewContentHeight - self.bounds.size.height + view.extendBottom;
                if(!self.isDragging && view.state == SVInfiniteScrollingStateTriggered)
                    view.state = SVInfiniteScrollingStateLoading;
                else if(self.isDragging && view.state == SVInfiniteScrollingStatePulling && self.contentOffset.y - scrollOffsetThreshold > SVInfiniteScrollingViewHeight)
                    view.state = SVInfiniteScrollingStateTriggered;
                else if(self.contentOffset.y - scrollOffsetThreshold >0 && self.contentOffset.y - scrollOffsetThreshold<SVInfiniteScrollingViewHeight )
                    view.state = SVInfiniteScrollingStatePulling;
                else if(self.contentOffset.y < scrollOffsetThreshold && view.state != SVInfiniteScrollingStateStopped)
                    view.state = SVInfiniteScrollingStateStopped;
            }
        }];
        
        [[RACObserve(self, contentSize) filter:^BOOL(id value) {
            @strongify(self);
            return self.contentSize.height>=self.bounds.size.height;
        }] subscribeNext:^(id x) {
            @strongify(self);
            self.showsInfiniteScrolling = YES;
        }];
    }

}

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler customer:(BOOL)customer{
    [self initInfiniteScrollingWithActionHandler:actionHandler];
    
    if (self.infiniteScrollingView) {
        [self addSubview:self.infiniteScrollingView];
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
    
    if(newState == SVInfiniteScrollingStateLoading && previousState == SVInfiniteScrollingStateTriggered && self.infiniteScrollingHandler && self.enabled)
        self.infiniteScrollingHandler();
    
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
