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
- (id)initAutoLayoutAddToView:(UIView *)superView;
- (void)endWithView:(UIView *)endview;
@end