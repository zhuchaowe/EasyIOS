//
//  Scene+NavBar.m
//  mcapp
//
//  Created by zhuchao on 15/2/12.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Scene+NavBar.h"
#import <objc/runtime.h>
static char SceneEZNavBar;

@implementation Scene (NavBar)

-(void)setNavBar:(EZNavBar *)navBar{
    [self willChangeValueForKey:@"navBar"];
    objc_setAssociatedObject(self, &SceneEZNavBar,
                             navBar,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"navBar"];
}

-(EZNavBar *)navBar {
    EZNavBar *bar = objc_getAssociatedObject(self, &SceneEZNavBar);
    if(bar.isNotEmpty){
        return bar;
    }else{
        EZNavBar *navBar = [[EZNavBar alloc]init];
        if(self.navigationController.navigationBar.barTintColor.isNotEmpty){
            navBar.backgroundColor = self.navigationController.navigationBar.barTintColor;
        }else if([UINavigationBar appearance].barTintColor.isNotEmpty){
            navBar.backgroundColor = [UINavigationBar appearance].barTintColor;
        }
        [self.view addSubview:navBar];
        self.automaticallyAdjustsScrollViewInsets=NO;//禁止自动调整
        [navBar alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:navBar.superview];
        [navBar constrainHeight:@"64"];
        self.navBar = navBar;
        return navBar;
    }
}

-(void)setTitle:(NSString *)title{
    UIColor *foregroundColor = [UIColor blackColor];
    UIFont *font = [UIFont systemFontOfSize:18.0f];
    
    if([self.navigationController.navigationBar.titleTextAttributes objectForKey:NSForegroundColorAttributeName]){
        foregroundColor = [self.navigationController.navigationBar.titleTextAttributes objectForKey:NSForegroundColorAttributeName];
    }else if ([[UINavigationBar appearance].titleTextAttributes objectForKey:NSForegroundColorAttributeName]){
        foregroundColor = [[UINavigationBar appearance].titleTextAttributes objectForKey:NSForegroundColorAttributeName];
    }
    if([self.navigationController.navigationBar.titleTextAttributes objectForKey:NSFontAttributeName]){
        font = [self.navigationController.navigationBar.titleTextAttributes objectForKey:NSFontAttributeName];
    }else if ([[UINavigationBar appearance].titleTextAttributes objectForKey:NSFontAttributeName]){
        font = [[UINavigationBar appearance].titleTextAttributes objectForKey:NSFontAttributeName];
    }

    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.textColor = foregroundColor;
    label.font = font;
    self.navBar.centerView = label;
}

-(void)addSubViewAlignTopNavBar:(UIView *)view{
    [self.view addSubview:view];
    [view constrainTopSpaceToView:self.navBar predicate:@"0"];
    [view alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:view.superview];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)showBarButton:(EzNavigationBar)position button:(UIButton *)button{
    if (NAV_LEFT == position) {
        [button addTarget:self action:@selector(leftButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        self.navBar.leftView = button;
        if (IOS7_OR_LATER) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if (NAV_RIGHT == position){
        [button addTarget:self action:@selector(rightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        self.navBar.rightView = button;
    }
}
#pragma clang diagnostic pop

@end
