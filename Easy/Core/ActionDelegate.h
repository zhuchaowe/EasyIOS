//
//  ActionDelegate.h
//  leway
//
//  Created by 朱潮 on 14-7-4.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActionDelegate <NSObject>
-(void)handleActionMsg:(Request *)msg;
@optional
-(void)handleProgressMsg:(Request *)msg;
@end
