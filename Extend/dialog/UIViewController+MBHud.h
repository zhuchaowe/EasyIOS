//
//  UIViewController+MBHud.h
//  mcapp
//
//  Created by zhuchao on 14/11/25.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface UIViewController (MBHud)
-(void)loadHudInKeyWindow;
-(void)loadHud:(UIView *)view;
-(MBProgressHUD *)showHudProgress:(NSString *)text;
-(void)showHudIndeterminate:(NSString *)text;
-(void)hideHud;
-(void)hideHudSuccess:(NSString *)text;
-(void)hideHudFailed:(NSString *)text;
@end
