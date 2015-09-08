//
//  UIView+EasyExtend.h
//  leway
//
//  Created by 朱潮 on 14-6-5.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EasyExtend)
/**
 *  location
 */
@property(nonatomic, assign) CGPoint origin;
@property(nonatomic, assign) CGFloat top;
@property(nonatomic, assign) CGFloat left;
@property(nonatomic, assign) CGFloat bottom;
@property(nonatomic, assign) CGFloat right;

/**
 *  center
 */
@property(nonatomic, assign) CGFloat centerY;
@property(nonatomic, assign) CGFloat centerX;

/**
 *  size
 */
@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) CGFloat width;

/**
 *  Other Origin
 */
@property(nonatomic, assign, readonly) CGPoint bottomLeft;
@property(nonatomic, assign, readonly) CGPoint bottomRight;
@property(nonatomic, assign, readonly) CGPoint topRight;

- (UIImage *)saveImageWithScale:(float)scale;
@end
