//
//  UITabBarController+EasyExtend.m
//  leway
//
//  Created by 朱潮 on 14-6-7.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "UITabBarController+EasyExtend.h"

NSString *const UITabNormalTextColor = @"NormalTextColor";
NSString *const UITabSelectedTextColor = @"SelectedTextColor";
NSString *const UITabItemsImageArray = @"ItemsImageArray";
NSString *const UITabItemsSelectedImage = @"selectedImage";
NSString *const UITabItemsNormalImage = @"normalImage";

@implementation UITabBarController (EasyExtend)

-(void)setTabBarItemsAttributes:(NSDictionary *)settingDict{
    NSArray *easyTabImageConfig = [NSArray array];
    if ([settingDict objectForKey:UITabItemsImageArray]) {
        easyTabImageConfig = [settingDict objectForKey:UITabItemsImageArray];
    }
    NSInteger i =0;
    for (UITabBarItem *item in self.tabBar.items) {
        if([settingDict objectForKey:UITabNormalTextColor]){
            [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                [settingDict objectForKey:UITabNormalTextColor],UITextAttributeTextColor,nil]
                                forState:UIControlStateNormal];
        }
        if([settingDict objectForKey:UITabSelectedTextColor]){
            [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                [settingDict objectForKey:UITabSelectedTextColor],UITextAttributeTextColor,nil]
                                forState:UIControlStateSelected];
        }
        if([easyTabImageConfig objectAtIndex:i]){
            NSDictionary *config = [easyTabImageConfig objectAtIndex:i];
            if ([config objectForKey:UITabItemsSelectedImage] && [config objectForKey:UITabItemsNormalImage]) {
                [item setFinishedSelectedImage:[UIImage imageNamed:[config objectForKey:UITabItemsSelectedImage]]
                   withFinishedUnselectedImage:[UIImage imageNamed:[config objectForKey:UITabItemsNormalImage]]];
            }
        }
        i++;
    }
    
    
}
@end
