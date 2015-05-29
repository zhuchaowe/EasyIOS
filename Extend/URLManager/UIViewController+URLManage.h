//
//  UIViewController+URLManage.h
//  rssreader
//
//  Created by zhuchao on 15/2/11.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (URLManage)
@property(nonatomic,retain)NSURL *originUrl;
@property(nonatomic,retain)NSString *path;
@property(nonatomic,retain)NSDictionary *params;
@property(nonatomic,retain)NSDictionary *dictQuery;

+ (UIViewController *)initFromString:(NSString *)aString fromConfig:(NSDictionary *)config;
+ (UIViewController *)initFromURL:(NSURL *)url fromConfig:(NSDictionary *)config;
+ (UIViewController *)initFromString:(NSString *)aString withQuery:(NSDictionary *)query fromConfig:(NSDictionary *)config;
+ (UIViewController *)initFromURL:(NSURL *)url withQuery:(NSDictionary *)query fromConfig:(NSDictionary *)config;
@end

