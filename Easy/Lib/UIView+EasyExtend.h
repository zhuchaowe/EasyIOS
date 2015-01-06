//
//  UIView+EasyExtend.h
//  leway
//
//  Created by 朱潮 on 14-6-5.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EasyExtend)
-(CGFloat)bottom;
-(CGFloat)top;
-(CGFloat)left;
-(CGFloat)right;
-(CGFloat)width;
-(CGFloat)height;
- (UIImage *)saveImageWithScale:(float)scale;
@end
