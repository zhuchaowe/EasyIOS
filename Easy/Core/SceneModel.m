//
//  SceneModel.m
//  NewEasy
//
//  Created by 朱潮 on 14-7-22.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SceneModel.h"

@implementation SceneModel

+(id)SceneModel{
    return [[self alloc]initModel];
}

- (id)initModel{
    self = [super init];
    if(self){
        self.action = [Action Action];
    }
    return self;
}

- (void)handleActionMsg:(ActionData *)msg{
    if(msg.sending){
        NSLog(@"sending:%@",msg.op.url);
    }else if(msg.succeed){
        NSLog(@"success:%@",msg.output);
    }else if(msg.failed){
        NSLog(@"failed:%@",msg.error);
    }
}

- (void)handleProgressMsg:(ActionData *)msg{

}

- (void)SEND_ACTION:(NSDictionary *)dict{
    
}

- (void)SEND_CACHE_ACTION:(NSDictionary *)dict{
    [self.action readFromCache];
    [self SEND_ACTION:dict];
}

- (void)SEND_NO_CACHE_ACTION:(NSDictionary *)dict{
    [self.action notReadFromCache];
    [self SEND_ACTION:dict];
}

@end
