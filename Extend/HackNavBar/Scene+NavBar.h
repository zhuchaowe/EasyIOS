//
//  Scene+NavBar.h
//  mcapp
//
//  Created by zhuchao on 15/2/12.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Scene.h"

@interface EZNavBar : UIView
@property(nonatomic,retain)UIView *centerView;
@property(nonatomic,retain)UIView *leftView;
@property(nonatomic,retain)UIView *rightView;
@end

@interface Scene (NavBar)
@property(nonatomic,retain)EZNavBar *navBar;
-(void)addSubViewAlignTopNavBar:(UIView *)view;
-(void)nav_setTitle:(NSString *)title;
- (void)nav_showBarButton:(EzNavigationBar)position title:(NSString *)name fontColor:(UIColor *)color;
- (void)nav_showBarButton:(EzNavigationBar)position imageName:(NSString *)imageName;
- (void)nav_showBarButton:(EzNavigationBar)position button:(UIButton *)button;
@end
