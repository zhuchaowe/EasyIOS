//
//  SceneScrollView.h
//  leway
//
//  Created by 朱潮 on 14-6-20.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneScrollView : UIScrollView
@property(nonatomic,strong)UIView *contentView;
- (void)addContentView;
- (void)endWithView:(UIView *)endview;
-(void)addHorizontalContentView;
-(void)addHorizontalSubView:(UIView *)view atIndex:(NSInteger)index;
-(void)endWithHorizontalView:(UIView *)endview;


- (void)horizontalConstrainTopSpaceToView:(UIView*)view predicate:(NSString*)predicate;
- (void)horizontalAlignTopWithView:(UIView*)view predicate:(NSString*)predicate;
- (void)horizontalAlignBottomWithView:(UIView*)view predicate:(NSString*)predicate;
@end