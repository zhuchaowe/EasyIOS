//
//  Action.h
//  article
//
//  Created by EasyIOS on 14-4-8.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//
#import "Easy.h"
#import "AFNetworking.h"
#import "Request.h"
#import "ActionDelegate.h"

@interface Action : NSObject
@property(nonatomic,weak)id<ActionDelegate> aDelegaete;
+(void)actionConfigHost:(NSString *)host client:(NSString *)client codeKey:(NSString *)codeKey rightCode:(NSInteger)rightCode msgKey:(NSString *)msgKey;
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
AS_SINGLETON(Action)
@end
