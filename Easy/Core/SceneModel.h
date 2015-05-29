//
//  SceneModel.h
//  NewEasy
//
//  Created by 朱潮 on 14-7-22.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Action.h"
#import "RACEXTScope.h"
#import "ReactiveCocoa.h"
#import "Request.h"
@interface SceneModel : NSObject
@property(nonatomic,strong)Action *action;
+ (id)SceneModel;
- (void)handleActionMsg:(Request *)msg;
- (void)DO_DOWNLOAD:(Request *)req;
- (void)SEND_ACTION:(Request *)req;
- (void)SEND_CACHE_ACTION:(Request *)req;
- (void)SEND_NO_CACHE_ACTION:(Request *)req;
- (void)SEND_IQ_ACTION:(Request *)req;
- (void)loadSceneModel;
@end
