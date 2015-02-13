//
//  Scene+NavBar.h
//  mcapp
//
//  Created by zhuchao on 15/2/12.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Scene.h"
#import "EZNavBar.h"

@interface Scene (NavBar)
@property(nonatomic,retain)EZNavBar *navBar;
-(void)addSubViewAlignTopNavBar:(UIView *)view;
@end
