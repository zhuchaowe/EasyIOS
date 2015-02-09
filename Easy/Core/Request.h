//
//  Request.h
//  NewEasy
//
//  Created by 朱潮 on 14-7-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyKit.h"
#import "AFHTTPRequestOperation.h"

extern NSString * const RequestStateSuccess;
extern NSString * const RequestStateFailed;
extern NSString * const RequestStateSending;
extern NSString * const RequestStateError;
extern NSString * const RequestStateCancle;

@interface Request : NSObject
@property(nonatomic,strong)NSDictionary * output;
@property(nonatomic,strong)NSString *responseString;
@property(nonatomic,strong)NSError *error;
@property(nonatomic,assign)NSString* state; //Request状态
@property(nonatomic,strong)NSURL *url;  //请求的链接
@property(nonatomic,strong)NSString *message;
@property(nonatomic,strong)NSString *codeKey;
@property(nonatomic,assign)double progress;
@property(nonatomic,assign)long long totalBytesWritten;
@property(nonatomic,assign)long long totalBytesExpectedToWrite;

@property(nonatomic,strong)NSString *downloadUrl;
@property(nonatomic,strong)NSString *targetPath;
@property(nonatomic,assign)long long totalBytesRead;
@property(nonatomic,assign)long long totalBytesExpectedToRead;

@property(nonatomic,assign)BOOL freezable;
@property(nonatomic,strong)NSDictionary *requestFiles;
@property(nonatomic,strong)NSString *SCHEME;
@property(nonatomic,strong)NSString *HOST;
@property(nonatomic,strong)NSString *PATH;
@property(nonatomic,strong)NSString *STATICPATH;
@property(nonatomic,strong)NSString *METHOD;
@property(nonatomic,assign)BOOL needCheckCode;
@property(nonatomic,strong)NSSet *acceptableContentTypes;
@property(nonatomic,strong)NSDictionary *httpHeaderFields;
@property(nonatomic,assign)BOOL requestNeedActive;
@property(nonatomic,strong)AFHTTPRequestOperation *op;
@property(nonatomic,copy)EZVoidBlock requestInActiveBlock;
-(NSString *)cacheKey;
+(id)Request;
+(id)RequestWithBlock:(EZVoidBlock)voidBlock;
-(void)loadRequest;
-(NSString *)requestKey;
+(NSString *)requestKey;
-(NSDictionary *)requestParams;
-(NSString *)pathInfo;
-(NSString *)appendPathInfo;
- (BOOL)succeed;
- (BOOL)sending;
- (BOOL)failed;
- (BOOL)cancled;
- (void)cancle;
@end
