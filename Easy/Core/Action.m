//
//  Action.m
//  article
//
//  Created by EasyIOS on 14-4-8.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Action.h"
#import "RACEXTScope.h"
@implementation Action

DEF_SINGLETON(Action)

+(id)Action{
    return [[[self class] alloc] init];
}

- (id)initWithCache
{
    self = [self init];
    [self useCache];
	return self;
}
-(void)useCache{

}
-(void)readFromCache{

}
-(void)notReadFromCache{

}
-(void)Send:(Request *)msg{
    if([msg.METHOD isEqualToString:@"GET"]){
         [self GET:msg];
    }else{
         [self POST:msg];
    }
}

-(void) GET:(Request *)msg
{
    NSString *baseUrl = @"";
    if([msg.SCHEME isEmpty] || [msg.HOST isEmpty]){
        baseUrl = [NSString stringWithFormat:@"http://%@",HOST_URL];
    }else{
        baseUrl = [NSString stringWithFormat:@"%@://%@",msg.SCHEME,msg.HOST];
    }
    
    NSDictionary *requestParams = nil;
    NSString *path = @"";
    if([msg.appendPathInfo isEmpty]){
        requestParams = msg.requestParams;
    }else{
        path = [msg.PATH stringByAppendingString:msg.appendPathInfo];
    }
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:baseUrl]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self sending:msg];
    @weakify(msg,self);
    [[manager rac_GET:path parameters:requestParams]
    subscribeNext:^(NSDictionary* jsonObject) {
         @strongify(msg,self);
        msg.output = jsonObject;
        [self checkCode:msg];
    } error:^(NSError *error) {
        @strongify(msg,self);
        msg.error = error;
        [self failed:msg];
    }];
}



-(void)POST:(Request *)msg{
    NSString *baseUrl = @"";
    if([msg.SCHEME isEmpty] || [msg.HOST isEmpty]){
        baseUrl = [NSString stringWithFormat:@"http://%@",HOST_URL];
    }else{
        baseUrl = [NSString stringWithFormat:@"%@://%@",msg.SCHEME,msg.HOST];
    }
    
    NSDictionary *requestParams = nil;
    NSString *path = @"";
    if([msg.appendPathInfo isEmpty]){
        requestParams = msg.requestParams;
    }else{
        path = [msg.PATH stringByAppendingString:msg.appendPathInfo];
    }
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:baseUrl]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self sending:msg];
    @weakify(msg,self);
    [[manager rac_POST :path parameters:requestParams]
     subscribeNext:^(NSDictionary* jsonObject) {
         @strongify(msg,self);
         msg.output = jsonObject;
         [self checkCode:msg];
     } error:^(NSError *error) {
         @strongify(msg,self);
         msg.error = error;
         [self failed:msg];
     }];
}

//-(void) POST:(Request *)msg
//{
//    NSString *url = @"";
//    if([msg.SCHEME isEmpty] || [msg.HOST isEmpty]){
//        url = [NSString stringWithFormat:@"http://%@%@",HOST_URL,msg.PATH];
//    }else{
//        url = [NSString stringWithFormat:@"%@://%@%@",msg.SCHEME,msg.HOST,msg.PATH];
//    }
//    NSDictionary *requestParams = nil;
//    if([msg.appendPathInfo isEmpty]){
//        requestParams = msg.requestParams;
//    }else{
//        url = [url stringByAppendingString:msg.appendPathInfo];
//    }
//    MKNetworkOperation *op = [self operationWithURLString:url
//                                                   params:requestParams
//                                               httpMethod:msg.METHOD];
//    msg.op = op;
//    NSDictionary *file = msg.requestFiles;
//    if([file count]>0){
//        for (NSString *key in [file allKeys]) {
//            [op addFile:[file objectForKey:key] forKey:key];
//        }
//        [op setFreezable:msg.freezable];
//    }
//    [self sending:msg];
//    NSLog(@"%@",op.url);
//    @weakify(msg,self);
//    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
//        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
//            @strongify(msg,self);
//            msg.responseString = completedOperation.responseString;
//            msg.output = jsonObject;
//            [self checkCode:msg];
//            if([completedOperation isCachedResponse]){
//                NSLog(@"iscache:YES");
//            }else{
//                NSLog(@"iscache:NO");
//            }
//        }];
//    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
//        @strongify(msg,self);
//        msg.error = error;
//        [self failed:msg];
//    }];
//    if([file count]>0){
//        [op onUploadProgressChanged:^(double progress) {
//            msg.progress = progress;
//            [self progressing:msg];
//        }];
//    }
//    [self enqueueOperation:op];
//    return op;
//}


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
