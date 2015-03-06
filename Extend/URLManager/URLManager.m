//
//  URLManager.m
//  rssreader
//
//  Created by zhuchao on 15/3/6.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "URLManager.h"

@implementation URLManager
+ (instancetype)manager{
    GCDSharedInstance(^{ return [[self alloc] init]; });
}

+(void)loadConfigFromPlist:(NSString *)plistPath{
    [URLManager manager].config = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
}

+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated{
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[URLManager manager].config];
    [URLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushURL:(NSURL *)url animated:(BOOL)animated{
    UIViewController *viewController = [UIViewController initFromURL:url fromConfig:[URLManager manager].config];
    [URLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated replace:(BOOL)replace{
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[URLManager manager].config];
    [URLNavigation pushViewController:viewController animated:YES replace:replace];
}

+ (void)pushURL:(NSURL *)url animated:(BOOL)animated replace:(BOOL)replace{
    UIViewController *viewController = [UIViewController initFromURL:url fromConfig:[URLManager manager].config];
    [URLNavigation pushViewController:viewController animated:animated replace:replace];
}

+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated{
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[URLManager manager].config];
    [URLNavigation presentViewController:viewController animated:animated];
}

+ (void)presentURL:(NSURL *)url animated:(BOOL)animated{
    UIViewController *viewController = [UIViewController initFromURL:url fromConfig:[URLManager manager].config];
    [URLNavigation presentViewController:viewController animated:animated];
}
@end