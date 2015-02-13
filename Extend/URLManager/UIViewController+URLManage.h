//
//  UIViewController+URLManage.h
//  rssreader
//
//  Created by zhuchao on 15/2/11.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface URLManager : NSObject
@property(nonatomic,retain)NSMutableDictionary *config;
-(void)loadConfigFromPlist:(NSString *)plistPath;
+ (URLManager *)sharedInstance;
@end


@interface UIViewController (URLManage)
@property(nonatomic,retain)NSURL *originUrl;
@property(nonatomic,retain)NSString *path;
@property(nonatomic,retain)NSDictionary *params;
@property(nonatomic,retain)NSDictionary *dictQuery;

+ (UIViewController *)initFromString:(NSString *)aString;
+ (UIViewController *)initFromURL:(NSURL *)url;
+ (UIViewController *)initFromString:(NSString *)aString withQuery:(NSDictionary *)query;
+ (UIViewController *)initFromURL:(NSURL *)url withQuery:(NSDictionary *)query;
@end

