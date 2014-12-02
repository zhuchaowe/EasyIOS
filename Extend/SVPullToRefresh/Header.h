//
//  Header.h
//  mcapp
//
//  Created by zhuchao on 14/11/21.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"

@interface Header : UIView
@property(nonatomic,assign) BOOL alignInset;
- (id)initWithFrame:(CGRect)frame with:(UIScrollView *)scrollView;
- (void)resetScrollViewContentInset:(UIScrollView *)scrollView;
- (void)setScrollViewContentInsetForLoading:(UIScrollView *)scrollView;
@end
