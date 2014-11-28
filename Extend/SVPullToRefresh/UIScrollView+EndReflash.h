//
//  UIScrollView+EndReflash.h
//  mcapp
//
//  Created by zhuchao on 14/11/28.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (EndReflash)
-(void)flashMessage:(NSString *)msg;
-(void)endAllRefreshingWithEnd:(BOOL)isEnd;
-(void)endAllRefreshingWithIntEnd:(NSInteger)num;
@end
