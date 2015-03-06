//
//  URLManager.h
//  rssreader
//
//  Created by zhuchao on 15/3/6.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "URLNavigation.h"
#import "UIViewController+URLManage.h"

@interface URLManager : NSObject
@property(nonatomic,retain)NSMutableDictionary *config;
+ (void)loadConfigFromPlist:(NSString *)plistPath;
+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated;
+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated replace:(BOOL)replace;
+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated;
@end
