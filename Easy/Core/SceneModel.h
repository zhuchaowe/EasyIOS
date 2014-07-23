//
//  SceneModel.h
//  NewEasy
//
//  Created by 朱潮 on 14-7-22.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Action.h"
#import "ReactiveCocoa.h"

@interface SceneModel : NSObject
@property(nonatomic,strong)Action *action;
+ (id)SceneModel;
- (void)handleActionMsg:(ActionData *)msg;
- (void)SEND_ACTION:(NSDictionary *)dict;
- (void)SEND_CACHE_ACTION:(NSDictionary *)dict;
- (void)SEND_NO_CACHE_ACTION:(NSDictionary *)dict;
- (id)initModel;
@end
