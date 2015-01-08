//
//  UIViewController+MBHud.m
//  mcapp
//
//  Created by zhuchao on 14/11/25.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "UIViewController+MBHud.h"
#import <objc/runtime.h>


static char MBHud;
@implementation UIViewController (MBHud)

- (void)setHud:(MBProgressHUD *)hud {
    [self willChangeValueForKey:@"MBProgressHUD"];
    objc_setAssociatedObject(self, &MBHud,
                             hud,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"MBProgressHUD"];
}

- (MBProgressHUD *)hud {
    return objc_getAssociatedObject(self, &MBHud);
}

-(void)loadHudInKeyWindow{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    self.hud = hud;
}

-(void)loadHud:(UIView *)view{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:hud];
    self.hud = hud;
}

-(MBProgressHUD *)showHudProgress:(NSString *)text{
    if (self.hud.superview) {
        [self.hud.superview bringSubviewToFront:self.hud];
    }
    self.hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    self.hud.labelText = text;
    [self.hud show:YES];
    return self.hud;
}

-(void)showHudIndeterminate:(NSString *)text{
    if (self.hud.superview) {
        [self.hud.superview bringSubviewToFront:self.hud];
    }
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = text;
    [self.hud show:YES];
}

-(void)hideHudSuccess:(NSString *)text{
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.customView = [IconFont labelWithIcon:[IconFont icon:@"fa_check" fromFont:fontAwesome] fontName:fontAwesome size:37.0f color:[UIColor whiteColor]];
    self.hud.labelText = text;
    [self.hud hide:YES afterDelay:1.0f];
}

-(void)hideHud{
    [self.hud hide:YES];
}

-(void)hideHudFailed:(NSString *)text{
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.customView = [IconFont labelWithIcon:[IconFont icon:@"fa_times" fromFont:fontAwesome] fontName:fontAwesome size:37.0f color:[UIColor whiteColor]];
    self.hud.labelText = text;
    [self.hud hide:YES afterDelay:1.0f];
}

@end
