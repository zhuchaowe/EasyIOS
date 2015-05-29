//
//  UIScrollView+TwitterCover.m
//  TwitterCover
//
//  Created by hangchen on 1/7/14.
//  Copyright (c) 2014 Hang Chen (https://github.com/cyndibaby905)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UIScrollView+CoverView.h"
#import <objc/runtime.h>
@interface CoverView()
@property (nonatomic, assign) CGRect rect;
@end

@implementation CoverView
- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    @weakify(self);
    
    [[RACObserve(scrollView, contentOffset)
    filter:^BOOL(id value) {
        return self.enable;
    }]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.scrollView.contentOffset.y < - self.rect.size.height) {
             CGFloat offset = - self.rect.size.height - self.scrollView.contentOffset.y;
             self.frame = CGRectMake(self.rect.origin.x-offset,self.rect.origin.y - offset, self.rect.size.width+ offset * 2, self.rect.size.height + offset);
         }else{
             self.frame = self.rect;
         }
     }];
}
@end

static char UIScrollViewCover;

@implementation UIScrollView (CoverView)

-(void)setCoverView:(CoverView *)coverView{
    [self willChangeValueForKey:@"coverView"];
    objc_setAssociatedObject(self, &UIScrollViewCover,
                             coverView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"coverView"];
}

-(CoverView *)coverView {
    return objc_getAssociatedObject(self, &UIScrollViewCover);
}

- (void)addCover:(UIView*)view size:(CGSize)size
{
    CoverView *coverView = [[CoverView alloc] init];
    coverView.scrollView = self;
    coverView.enable = YES;
    coverView.rect = CGRectMake(0,-size.height, size.width, size.height);
    [coverView addSubview:view];
    
    [view alignToView:coverView];
    
    self.coverView = coverView;
    UIEdgeInsets insets = self.contentInset;
    insets.top += size.height;
    self.contentInset = insets;
    [self addSubview:coverView];
}
@end