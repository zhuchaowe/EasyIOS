//
//  PullHeader.m
//  mcapp
//
//  Created by zhuchao on 14/11/21.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "PullHeader.h"

@implementation PullHeader

- (id)initWithScrollView:(UIScrollView *)scrollView
{
    self = [super initWithScrollView:scrollView];
    if (self) {
        
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-down"]];
        _arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_arrowImage];

        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.autoresizingMask = _arrowImage.autoresizingMask;
        _activityView.hidden = YES;
        [self addSubview:_activityView];
       
    
        [self addSubview:_lastUpdateTimeLabel = [self labelWithFontSize:12]];
        [self addSubview:_statusLabel = [self labelWithFontSize:13]];
        
        [self loadAutoLayout];
        
        @weakify(self);
        [RACObserve(scrollView.pullToRefreshView, state) subscribeNext:^(id x) {
            @strongify(self);
            [UIView animateWithDuration:0.25f animations:^{
                switch (scrollView.pullToRefreshView.state) {
                 
                    case SVPullToRefreshStateStopped:
                        [self resetScrollViewContentInset:scrollView];
                        self.arrowImage.hidden = NO;
                        [self.activityView stopAnimating];
                        self.statusLabel.text = @"下拉可以刷新";
                        self.arrowImage.transform = CGAffineTransformIdentity;
                        [self updateTimeLabel:[NSDate date]];
                        break;
                    case SVPullToRefreshStatePulling:
                        self.arrowImage.hidden = NO;
                        [self.activityView stopAnimating];
                        self.statusLabel.text = @"下拉可以刷新";
                        self.arrowImage.transform = CGAffineTransformIdentity;
                        break;
                    case SVPullToRefreshStateTriggered:
                        self.arrowImage.hidden = NO;
                        [self.activityView stopAnimating];
                        self.statusLabel.text = @"释放可以刷新";
                        self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                        break;
                    case SVPullToRefreshStateLoading:
                         [self setScrollViewContentInsetForLoading:scrollView];
                        self.arrowImage.hidden = YES;
                        [self.activityView startAnimating];
                        self.statusLabel.text = @"正在刷新...";
                        break;
                }
            }];
        }];

        
        [self setHeaderFrame:scrollView];
    }
    return self;
}

//这里的pullToRefreshView使用autolayout布局各种出问题，
//暂时没有完美的解决方案，先用frame顶着，哪位大神看不下去了来改改？
-(void)setHeaderFrame:(UIScrollView *)scrollView{
    //yOrigin = - scrollView.pullToRefreshView.originalTopInset -SVPullToRefreshViewHeight;
    self.frame = CGRectMake(0, 0, scrollView.superview.width, SVPullToRefreshViewHeight);
    scrollView.pullToRefreshView.frame = CGRectMake(0, - SVPullToRefreshViewHeight, scrollView.superview.width, SVPullToRefreshViewHeight);
}

-(void)loadAutoLayout{
    [_arrowImage alignCenterYWithView:_arrowImage.superview predicate:@"0"];
    
    [_activityView alignToView:_arrowImage];

    [_statusLabel alignTopEdgeWithView:_statusLabel.superview predicate:@"10"];
    [_statusLabel alignCenterXWithView:_statusLabel.superview predicate:@"0"];
    
    [_lastUpdateTimeLabel constrainLeadingSpaceToView:_arrowImage predicate:@"30"];
    [_lastUpdateTimeLabel alignBottomEdgeWithView:_lastUpdateTimeLabel.superview predicate:@"-10"];
    [_lastUpdateTimeLabel alignCenterXWithView:_lastUpdateTimeLabel.superview predicate:@"0"];
}

- (UILabel *)labelWithFontSize:(CGFloat)size
{
    UILabel *label = [[UILabel alloc] init];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:size];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)updateTimeLabel:(NSDate *)date
{
    if (!date) return;
    
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:date];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        formatter.dateFormat = @"今天 HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:date];
    
    // 3.显示日期
    _lastUpdateTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
}


@end
