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

typedef enum
{
    EXTEND_NONE                  =0,
    EXTEND_TOP                   =1,
    EXTEND_BOTTOM                =2,
    EXTEND_TOP_BOTTOM            =3,
} EzAlignExtend;

typedef enum
{
    INSET_NONE                  =0,
    INSET_TOP                   =1,
    INSET_BOTTOM                =2,
    INSET_TOP_BOTTOM            =3,
} EzAlignInset;
#import "UIViewController+HUD.h"
@interface Scene : UIViewController
@property(nonatomic,retain)Scene *parentScene;

- (void)showBarButton:(EzNavigationBar)position title:(NSString *)name fontColor:(UIColor *)color;
- (void)showBarButton:(EzNavigationBar)position imageName:(NSString *)imageName;
- (void)showBarButton:(EzNavigationBar)position button:(UIButton *)button;
- (void)leftButtonTouch;
- (void)rightButtonTouch;
- (void)setTitleView:(UIView *)titleView;
- (void)addSubView:(UIView *)view
           extend:(EzAlignExtend)extend;
- (void)addScrollView:(UIScrollView *)view
            extend:(EzAlignExtend)extend
             inset:(EzAlignInset)inset;
@end
