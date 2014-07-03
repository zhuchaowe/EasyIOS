//
//  Scene.h
//  fastSign
//
//  Created by EasyIOS on 14-4-11.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Action.h"
#import "Easy.h"
#import "MJRefresh.h"
typedef enum
{
    NAV_LEFT                    =0,
    NAV_RIGHT                   =1,
} EzNavigationBar;


@interface Scene : UIViewController
@property(nonatomic,strong)Action *action;
@property(nonatomic,assign)BOOL hasAddActionObserver;
@property(nonatomic,assign)Scene *parentScene;
-(void)handleActionMsg:(ActionData *)msg;
-(void)handlePullLoader:(MJRefreshBaseView *)view state:(NSInteger)state;
- (void)SEND_ACTION:(NSDictionary *)dict;
- (void)SEND_ACTION;
- (void)SEND_CACHE_ACTION;
- (void)SEND_NO_CACHE_ACTION;
- (void)showBarButton:(EzNavigationBar)position title:(NSString *)name fontColor:(UIColor *)color;
- (void)showBarButton:(EzNavigationBar)position imageName:(NSString *)imageName;
- (void)showBarButton:(EzNavigationBar)position button:(UIButton *)button;
- (void)leftButtonTouch;
- (void)rightButtonTouch;
- (void)initAction;
@end
