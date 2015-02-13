//
//  Scene+NavBar.h
//  mcapp
//
//  Created by zhuchao on 15/2/12.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

// 使用本类中得方法请先执行，且仅执行一次以下3个方法，
//[$ swizzleMethod:@selector(setTitle:) with:@selector(nav_setTitle:) in:[Scene class]];
//[$ swizzleMethod:@selector(showBarButton:button:) with:@selector(nav_showBarButton:button:) in:[Scene class]];
//[$ swizzleMethod:@selector(setTitleView:) with:@selector(nav_setTitleView:) in:[Scene class]];


#import "Scene.h"

@interface EZNavBar : UIView
@property(nonatomic,retain)UIView *centerView;
@property(nonatomic,retain)UIView *leftView;
@property(nonatomic,retain)UIView *rightView;
@end

@interface Scene (NavBar)
@property(nonatomic,retain)EZNavBar *navBar;
-(void)nav_setTitle:(NSString *)title;
-(void)nav_setTitleView:(UIView *)titleView;
-(void)nav_showBarButton:(EzNavigationBar)position button:(UIButton *)button;
@end
