//
//  UIViewController+HUD.h
//  mcapp
//
//  Created by xzh. on 15/8/28.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (HUD)
#pragma mark - 任务型
- (MBProgressHUD *)showIndeterminateHUDWithText:(NSString *)text yOffset:(CGFloat)offset forKey:(NSString *)key;
- (MBProgressHUD *)showBarHUDWithText:(NSString *)text yOffset:(CGFloat)offset forKey:(NSString *)key;

#pragma mark - 过渡
- (void)successWithText:(NSString *)text forKey:(NSString *)key;
- (void)failWithText:(NSString *)text forKey:(NSString *)key;

#pragma mark - 提示性
- (MBProgressHUD *)showFailWithText:(NSString *)text yOffset:(CGFloat)offset;
- (MBProgressHUD *)showSuccessWithText:(NSString *)text yOffset:(CGFloat)offset;
- (MBProgressHUD *)showMessage:(NSString *)message yOffset:(CGFloat)offset;

#pragma mark - Hide & Show
- (void)hideHUD:(MBProgressHUD *)hud;
- (void)showHUD:(MBProgressHUD *)hud;

#pragma mark - 一次性
- (MBProgressHUD *)hudWithText:(NSString *)text
                        detail:(NSString *)detail
                        toView:(UIView *)view
                       yOffset:(CGFloat)offset;

- (NSMutableDictionary *)huds;

@end
