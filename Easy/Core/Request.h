//
//  Request.h
//  NewEasy
//
//  Created by 朱潮 on 14-7-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyKit.h"

typedef enum
{
    SuccessState                    =0,
    FailState                       =1,
    SendingState                    =2,
    ErrorState                      =3
} RequestState;

@interface Request : NSObject
@property(nonatomic,strong)NSDictionary * output;
@property(nonatomic,strong)NSString *responseString;
@property(nonatomic,strong)NSError *error;
@property(nonatomic,assign)RequestState state;
@property(nonatomic,retain)NSURL *url;
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
@property(nonatomic,retain)NSString *SCHEME;
@property(nonatomic,retain)NSString *HOST;
@property(nonatomic,retain)NSString *PATH;
@property(nonatomic,retain)NSString *STATICPATH;
@property(nonatomic,retain)NSString *METHOD;
@property(nonatomic,assign)BOOL needCheckCode;
@property(nonatomic,retain)NSSet *acceptableContentTypes;
@property (strong, nonatomic) NSDictionary *httpHeaderFields;
@property(nonatomic,assign)BOOL requestNeedActive;
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
@end
