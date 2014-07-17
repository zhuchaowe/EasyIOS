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
