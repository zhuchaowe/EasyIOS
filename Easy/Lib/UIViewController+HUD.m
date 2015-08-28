//
//  UIViewController+HUD.m
//  mcapp
//
//  Created by xzh. on 15/8/28.
//  Copyright (c) 2015年 xzh. All rights reserved.
//
static const CGFloat DELAY_TIME = 1;
static const char HUD_DIC = '\0';
#import <objc/runtime.h>
#import "UIViewController+HUD.h"

@implementation UIViewController (HUD)

#pragma mark - 创建
/**
 *  创建基本的HUD(隐藏后remove)
 */
- (MBProgressHUD *)hudWithText:(NSString *)text
                        detail:(NSString *)detail
                        toView:(UIView *)view
                       yOffset:(CGFloat)offset
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = text;
    hud.detailsLabelText = detail;
    hud.yOffset = offset;
    [view addSubview:hud];
    
    return hud;
}

#pragma mark - 任务型
- (MBProgressHUD *)showIndeterminateHUDWithText:(NSString *)text yOffset:(CGFloat)offset forKey:(NSString *)key
{
    MBProgressHUD *hud = [self hudWithText:text detail:nil toView:self.view yOffset:offset];
    [self showHUD:hud];
    [self.huds setObject:hud forKey:key];
    
    return hud;
}

- (MBProgressHUD *)showBarHUDWithText:(NSString *)text yOffset:(CGFloat)offset forKey:(NSString *)key
{
    MBProgressHUD *hud = [self hudWithText:text detail:nil toView:self.view yOffset:offset];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    [self showHUD:hud];
    [self.huds setObject:hud forKey:key];
    
    return hud;
}

#pragma mark - 过渡
- (void)successWithText:(NSString *)text forKey:(NSString *)key
{
    MBProgressHUD *hud = [self.huds objectForKey:key];
    if (hud) {
        [self successHUD:hud];
        hud.labelText = text;
        [hud hide:YES afterDelay:DELAY_TIME];
    }
}

- (void)failWithText:(NSString *)text forKey:(NSString *)key
{
    MBProgressHUD *hud = [self.huds objectForKey:key];
    if (hud) {
        [self failHUD:hud];
        hud.labelText = text;
        [hud hide:YES afterDelay:DELAY_TIME];
    }
}

#pragma mark - 提示性
- (MBProgressHUD *)showFailWithText:(NSString *)text yOffset:(CGFloat)offset
{
    MBProgressHUD *hud = [self hudWithText:text detail:nil toView:self.view yOffset:offset];
    [self failHUD:hud];
    [self showHUD:hud];
    [hud hide:YES afterDelay:DELAY_TIME];
    return hud;
}

- (MBProgressHUD *)showSuccessWithText:(NSString *)text yOffset:(CGFloat)offset
{
    MBProgressHUD *hud = [self hudWithText:text detail:nil toView:self.view yOffset:offset];
    [self successHUD:hud];
    [self showHUD:hud];
    [hud hide:YES afterDelay:DELAY_TIME];
    return hud;
}

- (MBProgressHUD *)showMessage:(NSString *)message yOffset:(CGFloat)offset
{
    MBProgressHUD *hud = [self hudWithText:message detail:nil toView:self.view yOffset:offset];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 5.0f;
    hud.cornerRadius = 5.0f;
    [self showHUD:hud];
    [hud hide:YES afterDelay:DELAY_TIME];
    
    return hud;
}

#pragma mark - Hide
- (void)hideHUD:(MBProgressHUD *)hud
{
    [hud hide:YES];
}

#pragma mark - Private
- (void)showHUD:(MBProgressHUD *)hud
{
    if (hud.superview) {
        [hud.superview bringSubviewToFront:hud];
    }
    
    [hud show:YES];
}

- (void)failHUD:(MBProgressHUD *)hud
{
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [IconFont labelWithIcon:[IconFont icon:@"fa_times" fromFont:fontAwesome] fontName:fontAwesome size:37.0f color:[UIColor whiteColor]];

}

- (void)successHUD:(MBProgressHUD *)hud
{
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [IconFont labelWithIcon:[IconFont icon:@"fa_check" fromFont:fontAwesome] fontName:fontAwesome size:37.0f color:[UIColor whiteColor]];
}

#pragma mark - Property
- (NSMutableDictionary *)huds
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &HUD_DIC);
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        [self setHuds:dic];
    }
    return dic;
}

- (void)setHuds:(NSMutableDictionary *)huds
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &HUD_DIC);
    if (dic != huds) {
        [self willChangeValueForKey:@"huds"];
        objc_setAssociatedObject(self, &HUD_DIC, huds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"huds"];
    }
}


@end
