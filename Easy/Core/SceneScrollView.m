//
//  SceneScrollView.m
//  leway
//
//  Created by 朱潮 on 14-6-20.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SceneScrollView.h"

@implementation SceneScrollView

-(void)addContentView{
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    [self.contentView alignToView:self];
    [self.contentView alignLeading:@"0" trailing:@"0" toView:self.superview];
}

//结束后必须调用此函数，才可以设置autolayout contentsize
-(void)endWithView:(UIView *)endview{
    [endview alignBottomEdgeWithView:endview.superview predicate:@"0"];
}

-(void)addHorizontalContentView{
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    [self.contentView alignToView:self];
}

-(void)addHorizontalSubView:(UIView *)view atIndex:(NSInteger)index{
    [self.contentView addSubview:view];
    [view constrainWidthToView:self.superview predicate:@"0"];
    [view alignTop:@"0" bottom:@"0" toView:view.superview];
    [view alignLeadingEdgeWithView:view.superview predicate:[NSString stringWithFormat:@"%f",self.superview.width*index]];
}

-(void)endWithHorizontalView:(UIView *)endview{
    [endview alignTrailingEdgeWithView:endview.superview predicate:@"0"];
}

- (void)horizontalConstrainTopSpaceToView:(UIView*)view predicate:(NSString*)predicate{
    [self constrainTopSpaceToView:view predicate:predicate];
    [self.contentView constrainTopSpaceToView:view predicate:predicate];
}

- (void)horizontalAlignTopWithView:(UIView*)view predicate:(NSString*)predicate{
    [self alignTopEdgeWithView:view predicate:predicate];
    [self.contentView alignTopEdgeWithView:view predicate:predicate];
}

- (void)horizontalAlignBottomWithView:(UIView*)view predicate:(NSString*)predicate{
    [self alignBottomEdgeWithView:view predicate:predicate];
    [self.contentView alignBottomEdgeWithView:view predicate:predicate];
}

@end
