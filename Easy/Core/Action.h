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

#define HOST_URL @"test-leway.zjseek.com.cn:8000"
#define CLIENT   @"easyIOS"
#define BASE_URL @"/api/"
#define CODE_KEY @"code"
#define RIGHT_CODE 0
#define MSG_KEY  @"msg"

@interface Action : MKNetworkEngine
typedef Action *	(^ActionBlockN)(id first ,id second,... );
@property(nonatomic,strong) ActionData *msg;
@property (nonatomic, readonly) ActionBlockN GET_MSG;
@property (nonatomic, readonly) ActionBlockN POST_MSG;
+ (id)Action;
- (id)initWithCache;

-(MKNetworkOperation*) GET:(NSString*) path
                    params:(NSDictionary *) params;

-(MKNetworkOperation*) POST:(NSString*) path
                     params:(NSDictionary *) params;

AS_SINGLETON(Action)
@end
