//
//  Action.h
//  article
//
//  Created by EasyIOS on 14-4-8.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//
#import "Easy.h"
#import "MKNetworkEngine.h"
#import "ActionData.h"
#import "ActionDelegate.h"

#define HOST_URL @"test-leway.zjseek.com.cn:8000"
//#define HOST_URL @"leway.com"
#define CLIENT   @"easyIOS"
#define BASE_URL @"/api/"
#define CODE_KEY @"code"
#define RIGHT_CODE 0
#define MSG_KEY  @"msg"

@interface Action : MKNetworkEngine
typedef Action *	(^ActionBlockN)(id first ,id second,id third,... );
typedef Action *	(^ActionBlockTN)(id first ,id second,... );

@property (nonatomic, readonly) ActionBlockTN GET_MSG;
@property (nonatomic, readonly) ActionBlockN POST_MSG;
@property(nonatomic,strong)id<ActionDelegate> aDelegaete;
+ (id)Action;
- (id)initWithCache;
- (void)success:(ActionData *)msg;
- (void)error:(ActionData *)msg;
- (void)failed:(ActionData *)msg;
-(MKNetworkOperation*) GET:(NSString*) path
                    params:(NSDictionary *) params
                       key:(NSString *)key;

-(MKNetworkOperation*) POST:(NSString*) path
                       file:(NSDictionary *) file
                     params:(NSDictionary *) params
                        key:(NSString *)key;

AS_SINGLETON(Action)
@end
