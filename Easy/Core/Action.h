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

//以下配置为调用Action 类必须 配置
#ifndef HOST_CONFIG
#define HOST_URL @"test-leway.zjseek.com.cn:8000" //服务端域名:端口
#define CLIENT   @"easyIOS"                       //自定义客户端识别
#define BASE_URL @"/api/"                         //基础路由，如无基础路由可为空
#define CODE_KEY @"code"                          //错误码key,支持路径 如 data/code
#define RIGHT_CODE 0                              //正确校验码
#define MSG_KEY  @"msg"                           //消息提示msg,支持路径 如 data/msg
#endif


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
