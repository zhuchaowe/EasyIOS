//
//  Action.h
//  article
//
//  Created by EasyIOS on 14-4-8.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//
#import "Easy.h"
#import <AFNetworking/AFNetworking.h>
#import "Request.h"
#import "ActionDelegate.h"

@interface Action : NSObject
@property(nonatomic,weak)id<ActionDelegate> aDelegaete;
+(void)actionConfigScheme:(NSString *)scheme
                     host:(NSString *)host
                   client:(NSString *)client
                  codeKey:(NSString *)codeKey
                rightCode:(NSInteger)rightCode
                   msgKey:(NSString *)msgKey;
+(void)actionConfigHost:(NSString *)host
                 client:(NSString *)client
                codeKey:(NSString *)codeKey
              rightCode:(NSInteger)rightCode
                 msgKey:(NSString *)msgKey DEPRECATED_MSG_ATTRIBUTE("Use actionConfigScheme: method instead.");

+ (id)Action;
- (id)initWithCache;
- (void)success:(Request *)msg;
- (void)error:(Request *)msg;
- (void)failed:(Request *)msg;
- (void)useCache;
- (void)readFromCache;
- (void)notReadFromCache;
- (AFHTTPSessionManager *)Send:(Request *) msg;
- (AFHTTPSessionManager *)Download:(Request *)msg;


/**
 *  添加公共请求头
 */
+ (void)addCommonHeaderFields:(NSDictionary<NSString *, NSString *> *)headerFields;
AS_SINGLETON(Action)
@end
