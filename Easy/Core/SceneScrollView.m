//
//  SceneScrollView.m
//  leway
//
//  Created by 朱潮 on 14-6-20.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SceneScrollView.h"

@implementation SceneScrollView

- (id)initAutoLayoutAddToView:(UIView *)superView
{
    self = [super init];
    if (self) {
        [superView addSubview:self];
        [self alignToView:self.superview];
        [self loadContentView];
    }
    return self;
}

- (id)initAutoLayoutWithNavBar:(UIView *)navBar addToView:(UIView *)superView
{
    self = [super init];
    if (self) {
        [superView addSubview:self];
        [self constrainTopSpaceToView:navBar predicate:@"0"];
        [self alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self.superview];
        [self loadContentView];
    }
    return self;
}

-(void)loadContentView{
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    [self.contentView alignToView:self];
    [self.contentView alignLeading:@"0" trailing:@"0" toView:self.superview];
}

//结束后必须调用此函数，才可以设置autolayout contentsize
-(void)endWithView:(UIView *)endview{
    [endview alignBottomEdgeWithView:endview.superview predicate:@"0"];
}
@end
