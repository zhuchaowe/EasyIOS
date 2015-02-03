//
//  Action.m
//  article
//
//  Created by EasyIOS on 14-4-8.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Action.h"
#import "RACEXTScope.h"
#import "TMCache.h"

@interface Action()
@property(nonatomic,assign)BOOL cacheEnable;
@property(nonatomic,assign)BOOL dataFromCache;

@property(nonatomic,retain)NSString *HOST_URL;//服务端域名:端口
@property(nonatomic,retain)NSString *CLIENT;//自定义客户端识别
@property(nonatomic,retain)NSString *CODE_KEY;//错误码key,支持路径 如 data/code
@property(nonatomic,assign)NSUInteger RIGHT_CODE;//正确校验码
@property(nonatomic,retain)NSString *MSG_KEY;//消息提示msg,支持路径 如 data/msg
@end
@implementation Action

DEF_SINGLETON(Action)
+(void)actionConfigHost:(NSString *)host client:(NSString *)client codeKey:(NSString *)codeKey rightCode:(NSInteger)rightCode msgKey:(NSString *)msgKey{
    [Action sharedInstance].HOST_URL = host;
    [Action sharedInstance].CLIENT = client;
    [Action sharedInstance].CODE_KEY = codeKey;
    [Action sharedInstance].RIGHT_CODE = rightCode;
    [Action sharedInstance].MSG_KEY = msgKey;
}

+(id)Action{
    return [[[self class] alloc] init];
}
- (id)init
{
    self = [super init];
    if(self){
        _cacheEnable = NO;
        _dataFromCache = NO;
    }
    return self;
}

- (id)initWithCache
{
    self = [self init];
    _cacheEnable = YES;
    return self;
}

-(void)useCache{
    _cacheEnable = YES;
}

-(void)readFromCache{
    _dataFromCache = YES;
}
-(void)notReadFromCache{
    _dataFromCache = NO;
}

-(AFHTTPRequestOperation *)Download:(Request *)msg{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:msg.downloadUrl]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:msg.downloadUrl]];
    [self sending:msg];
    @weakify(msg,self);
    AFHTTPRequestOperation *op = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(msg,self);
        msg.output = [NSDictionary dictionary];
        [self successAction:msg];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(msg,self);
        msg.error = error;
        [self failed:msg];
    }];
    op.outputStream = [NSOutputStream outputStreamToFileAtPath:msg.targetPath append:NO];
    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        @strongify(msg,self);
        msg.totalBytesRead = totalBytesRead;
        msg.totalBytesExpectedToRead = totalBytesExpectedToRead;
        msg.progress = (CGFloat)totalBytesRead/(CGFloat)totalBytesExpectedToRead;
        [self progressing:msg];
    }];
    msg.url = op.request.URL;
    [op start];
    return op;
}

-(AFHTTPRequestOperation *)Send:(Request *)msg{
    if([msg.METHOD isEqualToString:@"GET"]){
        return [self GET:msg];
    }else{
        return [self POST:msg];
    }
}

-(AFHTTPRequestOperation *) GET:(Request *)msg
{
    NSString *url = @"";
    NSDictionary *requestParams = nil;
    if(msg.STATICPATH.isNotEmpty){
        url = msg.STATICPATH;
    }else{
        if(msg.SCHEME.isNotEmpty && msg.HOST.isNotEmpty){
            url = [NSString stringWithFormat:@"%@://%@%@",msg.SCHEME,msg.HOST,msg.PATH];
        }else{
            url = [NSString stringWithFormat:@"http://%@%@",[Action sharedInstance].HOST_URL,msg.PATH];
        }
        if(msg.appendPathInfo.isNotEmpty){
            url = [url stringByAppendingString:msg.appendPathInfo];
        }else{
            requestParams = msg.requestParams;
        }
    }
    
    [self sending:msg];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:url]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if(msg.httpHeaderFields.isNotEmpty){
        [msg.httpHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            [manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    if (msg.acceptableContentTypes.isNotEmpty) {
        manager.responseSerializer.acceptableContentTypes = msg.acceptableContentTypes;
    }
    
    @weakify(msg,self);
    AFHTTPRequestOperation *op =  [manager GET:url parameters:requestParams success:^(AFHTTPRequestOperation *operation, NSDictionary* jsonObject) {
        @strongify(msg,self);
        if(_cacheEnable){
            [[TMCache sharedCache] setObject:jsonObject forKey:msg.cacheKey block:^(TMCache *cache, NSString *key, id object) {
                EZLog(@"%@ has cached",url);
            }];
        }
        msg.output = jsonObject;
        [self checkCode:msg];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(msg,self);
        msg.error = error;
        [self failed:msg];
    }];
    msg.url = op.request.URL;
    msg.output = [[TMCache sharedCache] objectForKey:msg.cacheKey];
    if (_dataFromCache == YES && msg.output !=nil) {
        [[GCDQueue mainQueue] queueBlock:^{
            [self checkCode:msg];
        } afterDelay:0.1f];
    }
    return op;
}


-(AFHTTPRequestOperation *)POST:(Request *)msg{
    NSString *url = @"";
    NSDictionary *requestParams = nil;
    if(msg.STATICPATH.isNotEmpty){
        url = msg.STATICPATH;
    }else{
        if(msg.SCHEME.isNotEmpty && msg.HOST.isNotEmpty){
            url = [NSString stringWithFormat:@"%@://%@%@",msg.SCHEME,msg.HOST,msg.PATH];
        }else{
            url = [NSString stringWithFormat:@"http://%@%@",[Action sharedInstance].HOST_URL,msg.PATH];
        }
        if(msg.appendPathInfo.isNotEmpty){
            url = [url stringByAppendingString:msg.appendPathInfo];
        }else{
            requestParams = msg.requestParams;
        }
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if(msg.httpHeaderFields.isNotEmpty){
        [msg.httpHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            [manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    if (msg.acceptableContentTypes.isNotEmpty) {
        manager.responseSerializer.acceptableContentTypes = msg.acceptableContentTypes;
    }
    [self sending:msg];
    @weakify(msg,self);
    
    NSDictionary *file = msg.requestFiles;
    AFHTTPRequestOperation *op = [manager POST:url parameters:requestParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if([file count]>0){
            for (NSString *key in [file allKeys]) {
                [formData appendPartWithFileURL:[file objectForKey:key] name:key error:nil];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, NSDictionary* jsonObject) {
        @strongify(msg,self);
        if([file count] == 0 && _cacheEnable){
            [[TMCache sharedCache] setObject:jsonObject forKey:msg.cacheKey block:^(TMCache *cache, NSString *key, id object) {
                EZLog(@"%@ has cached",url);
            }];
        }
        msg.output = jsonObject;
        [self checkCode:msg];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(msg,self);
        msg.error = error;
        [self failed:msg];
    }];
    msg.url = op.request.URL;
    if(file.count >0){
        [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            @strongify(msg,self);
            msg.totalBytesWritten = totalBytesWritten;
            msg.totalBytesExpectedToWrite = totalBytesExpectedToWrite;
            msg.progress = (CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite;
            [self progressing:msg];
        }];
    }else{
        msg.output = [[TMCache sharedCache] objectForKey:msg.cacheKey];
        if (_dataFromCache == YES && msg.output !=nil) {
            [[GCDQueue mainQueue] queueBlock:^{
                [self checkCode:msg];
            } afterDelay:0.1f];
        }
    }
    return op;
}

-(void)checkCode:(Request *)msg{
    if (msg.needCheckCode) {
        msg.codeKey = [msg.output objectAtPath:[Action sharedInstance].CODE_KEY];
        if([msg.output objectAtPath:[Action sharedInstance].CODE_KEY] && [[msg.output objectAtPath:[Action sharedInstance].CODE_KEY] intValue] == [Action sharedInstance].RIGHT_CODE){
            [self success:msg];
        }else{
            [self error:msg];
        }
    }else{
        [self successAction:msg];
    }
}

-(void)sending:(Request *)msg{
    msg.state = SendingState;
    if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
        [self.aDelegaete handleActionMsg:msg];
    }
}

- (void)success:(Request *)msg{
    msg.message = [msg.output objectAtPath:[Action sharedInstance].MSG_KEY];
    [self successAction:msg];
}

-(void)successAction:(Request *)msg{
    msg.state = SuccessState;
    if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
        [self.aDelegaete handleActionMsg:msg];
    }
}

- (void)failed:(Request *)msg{
    if(msg.error.userInfo!= nil && [msg.error.userInfo objectForKey:@"NSLocalizedDescription"]){
        msg.message = [msg.error.userInfo objectForKey:@"NSLocalizedDescription"];
    }
    msg.state = FailState;
    NSLog(@"Failed:%@",msg.error);
    if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
        [self.aDelegaete handleActionMsg:msg];
    }
}

- (void)error:(Request *)msg{
    if([msg.output objectAtPath:[Action sharedInstance].MSG_KEY]){
        msg.message = [msg.output objectAtPath:[Action sharedInstance].MSG_KEY];
        NSLog(@"Error:%@",msg.message);
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
