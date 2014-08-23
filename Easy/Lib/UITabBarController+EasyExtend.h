//
//  UITabBarController+EasyExtend.h
//  leway
//
//  Created by 朱潮 on 14-6-7.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const UITabNormalTextColor;
extern NSString *const UITabSelectedTextColor;
extern NSString *const UITabItemsImageArray;
extern NSString *const UITabItemsSelectedImage;
extern NSString *const UITabItemsNormalImage;

@interface UITabBarController (EasyExtend)
-(void)setTabBarItemsAttributes:(NSDictionary *)settingDict;
@end
