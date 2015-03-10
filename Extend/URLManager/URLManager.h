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
+ (instancetype)manager;
+ (void)loadConfigFromPlist:(NSString *)plistPath;

+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated;
+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated replace:(BOOL)replace;

+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated;
+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated replace:(BOOL)replace;

+ (void)pushURL:(NSURL *)url animated:(BOOL)animated;
+ (void)pushURL:(NSURL *)url animated:(BOOL)animated replace:(BOOL)replace;

+ (void)pushURL:(NSURL *)url query:(NSDictionary *)query animated:(BOOL)animated;
+ (void)pushURL:(NSURL *)url query:(NSDictionary *)query animated:(BOOL)animated replace:(BOOL)replace;

+ (void)presentURL:(NSURL *)url animated:(BOOL)animated;
+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated;

+ (void)presentURL:(NSURL *)url query:(NSDictionary *)query animated:(BOOL)animated;
+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated;

+ (void)presentURL:(NSURL *)url animated:(BOOL)animated withNavigationClass:(Class)clazz;
+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated withNavigationClass:(Class)clazz;

+ (void)presentURL:(NSURL *)url query:(NSDictionary *)query animated:(BOOL)animated withNavigationClass:(Class)clazz;
+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated withNavigationClass:(Class)clazz;

@end


