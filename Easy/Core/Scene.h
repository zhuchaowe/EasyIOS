//
//  Scene.h
//  fastSign
//
//  Created by EasyIOS on 14-4-11.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Easy.h"
typedef enum
{
    NAV_LEFT                    =0,
    NAV_RIGHT                   =1,
} EzNavigationBar;


@interface Scene : UIViewController
@property(nonatomic,retain)Scene *parentScene;

- (void)showBarButton:(EzNavigationBar)position title:(NSString *)name fontColor:(UIColor *)color;
- (void)showBarButton:(EzNavigationBar)position imageName:(NSString *)imageName;
- (void)showBarButton:(EzNavigationBar)position button:(UIButton *)button;
- (void)leftButtonTouch;
- (void)rightButtonTouch;
@end
