//
//  Action.m
//  article
//
//  Created by EasyIOS on 14-4-8.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Action.h"

@implementation Action

DEF_SINGLETON(Action)

+(id)Action{
    return [[[self class] alloc] init];
}

- (id)init
{
    self = [super initWithHostName:HOST_URL customHeaderFields:@{@"x-client-identifier" : CLIENT}];
    return self;
}

- (id)initWithCache
{
    self = [self init];
    [self useCache];
	return self;
}

-(MKNetworkOperation*)Send:(Request *)msg{
    if([msg.METHOD isEqualToString:@"GET"]){
        return [self GET:msg];
    }else{
        return [self POST:msg];
    }
}

-(MKNetworkOperation*) GET:(Request *)msg
{
    NSURL *host = [NSURL URLWithString:msg.HOST];
    NSString *url = nil;
    if([host scheme] != nil){
        url = [NSString stringWithFormat:@"http://%@%@",host,msg.PATH];
    }else{
        url = [NSString stringWithFormat:@"http://%@%@",HOST_URL,msg.PATH];
    }
    MKNetworkOperation *op = [self operationWithURLString:url
                                              params:msg.requestParams
                                          httpMethod:msg.METHOD];
    msg.op = op;
    [self sending:msg];
    
    NSLog(@"%@",msg.op.url);
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            msg.responseString = completedOperation.responseString;
            msg.output = jsonObject;
            [self checkCode:msg];
            if([completedOperation isCachedResponse]){
                NSLog(@"iscache:YES");
            }else{
                NSLog(@"iscache:NO");
            }
        }];
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        msg.error = error;
        [self failed:msg];
    }];
    [self enqueueOperation:op];
    return op;
}

-(MKNetworkOperation*) POST:(Request *)msg
{
    NSURL *host = [NSURL URLWithString:msg.HOST];
    NSString *url = nil;
    if([host scheme] != nil){
        url = [NSString stringWithFormat:@"http://%@%@",host,msg.PATH];
    }else{
        url = [NSString stringWithFormat:@"http://%@%@",HOST_URL,msg.PATH];
    }
    MKNetworkOperation *op = [self operationWithURLString:url
                                                   params:msg.requestParams
                                               httpMethod:msg.METHOD];
    msg.op = op;
    NSDictionary *file = msg.requestFiles;
    if([file count]>0){
        for (NSString *key in [file allKeys]) {
            [op addFile:[file objectForKey:key] forKey:key];
        }
        [op setFreezable:msg.freezable];
    }
    [self sending:msg];
    NSLog(@"%@",op.url);
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            msg.responseString = completedOperation.responseString;
            msg.output = jsonObject;
            [self checkCode:msg];
            if([completedOperation isCachedResponse]){
                NSLog(@"iscache:YES");
            }else{
                NSLog(@"iscache:NO");
            }
        }];
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        msg.error = error;
        [self failed:msg];
    }];
    if([file count]>0){
        [op onUploadProgressChanged:^(double progress) {
            msg.progress = progress;
            [self progressing:msg];
        }];
    }
    [self enqueueOperation:op];
    return op;
}


-(void)checkCode:(Request *)msg{
    if([msg.output objectAtPath:CODE_KEY] && [[msg.output objectAtPath:CODE_KEY] intValue] == RIGHT_CODE){
        [self success:msg];
    }else{
        [self error:msg];
    }
}

-(void)sending:(Request *)msg{
    msg.state = SendingState;
    if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
        [self.aDelegaete handleActionMsg:msg];
    }
}

- (void)success:(Request *)msg{
    msg.discription = [msg.output objectAtPath:MSG_KEY];
    if (msg.state != SuccessState) {
        msg.state = SuccessState;
        if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
            [self.aDelegaete handleActionMsg:msg];
        }
    }
}

- (void)failed:(Request *)msg{
    if(msg.error.userInfo!= nil && [msg.error.userInfo objectForKey:@"NSLocalizedDescription"]){
        msg.discription = [msg.error.userInfo objectForKey:@"NSLocalizedDescription"];
    }
    msg.state = FailState;
    NSLog(@"Failed:%@",msg.error);
    if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
        [self.aDelegaete handleActionMsg:msg];
    }
}

- (void)error:(Request *)msg{
    if([msg.output objectAtPath:MSG_KEY]){
        msg.discription = [msg.output objectAtPath:MSG_KEY];
        NSLog(@"Error:%@",msg.discription);
    }
    msg.state = ErrorState;
    if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
        [self.aDelegaete handleActionMsg:msg];
    }
}

-(void)progressing:(Request *)msg{
    if([self.aDelegaete respondsToSelector:@selector(handleProgressMsg:)]){
        [self.aDelegaete handleProgressMsg:msg];
    }
}

@end
