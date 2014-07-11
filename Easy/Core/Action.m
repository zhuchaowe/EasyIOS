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

//1、params
//2、key params

- (ActionBlockTN)GET_MSG
{
	ActionBlockTN block = ^ Action * ( id first,id second,... )
	{
        if ( first && second)
		{
            if ( [second isKindOfClass:[NSDictionary class]] )
			{
                NSString * path = (NSString *)first;
				NSDictionary *	params = (NSDictionary *)second;
                [self GET:path params:params key:@""];
                
            }else{
                va_list args;
				va_start( args, second );
				
				NSString *	key = (NSString *)first;
                NSString * path = (NSString *)second;
				NSDictionary *	params = va_arg( args, NSDictionary * );
                
				if ( key && params )
				{
                    [self GET:path params:params key:key];
				}
				va_end( args );
            }
        }
        return self;
	};
	return [block copy];
}

//1、path params
//2、key path params
- (ActionBlockN)POST_MSG
{
	ActionBlockN block = ^ Action * ( id first,id second,id third,... )
	{
        if ( first && second && third)
		{
            if ( [second isKindOfClass:[NSDictionary class]] )
			{
                NSString * path = (NSString *)first;
                NSDictionary *files = (NSDictionary *)second;
				NSDictionary *params = (NSDictionary *)third;
                [self POST:path file:files params:params key:@""];
            }else{
                va_list args;
				va_start( args, third );
				
				NSString *key = (NSString *)first;
                NSString *path = (NSString *)second;
                NSDictionary *files = (NSDictionary *)third;
				NSDictionary *params = va_arg( args, NSDictionary * );
                
				if ( key && path)
				{
                    [self POST:path file:files params:params key:key];
				}
				va_end( args );
            }
        }
        return self;
	};
	return [block copy];
}

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

-(MKNetworkOperation*) GET:(NSString*) path
                    params:(NSDictionary *) params
                       key:(NSString *)key
{
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"%@%@",BASE_URL,path]
                                              params:params
                                          httpMethod:@"GET"];
    ActionData *msg = [ActionData Data];
    msg.op = op;
    msg.method = @"GET";
    msg.params = params;
    msg.path = path;
    msg.key = key;
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

-(MKNetworkOperation*) POST:(NSString*) path
                       file:(NSDictionary *) file
                     params:(NSDictionary *) params
                        key:(NSString *)key
{
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"%@%@",BASE_URL,path]
                                              params:params
                                          httpMethod:@"POST"];
    ActionData *msg = [ActionData Data];
    msg.op = op;
    msg.params = params;
    msg.path = path;
    msg.method = @"POST";
    msg.key = key;
    msg.files = file;
    for (NSString *key in [file allKeys]) {
        [op addFile:[file objectForKey:key] forKey:key];
    }
    [op setFreezable:NO];
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
    [op onUploadProgressChanged:^(double progress) {
        msg.progress = progress;
        [self progressing:msg];
    }];
    [self enqueueOperation:op];
    return op;
}


-(void)checkCode:(ActionData *)msg{
    if([msg.output objectForKey:CODE_KEY] && [[msg.output objectForKey:CODE_KEY] intValue] == RIGHT_CODE){
        [self success:msg];
    }else{
        [self error:msg];
    }
}

-(void)sending:(ActionData *)msg{
    msg.state = SendingState;
    if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
        [self.aDelegaete handleActionMsg:msg];
    }
}

- (void)success:(ActionData *)msg{
    msg.discription = [msg.output objectForKey:MSG_KEY];
    if (msg.state != SuccessState) {
        msg.state = SuccessState;
        if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
            [self.aDelegaete handleActionMsg:msg];
        }
    }
}

- (void)failed:(ActionData *)msg{
    if(msg.error.userInfo!= nil && [msg.error.userInfo objectForKey:@"NSLocalizedDescription"]){
        msg.discription = [msg.error.userInfo objectForKey:@"NSLocalizedDescription"];
    }
    msg.state = FailState;
    NSLog(@"Failed:%@",msg.error);
    if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
        [self.aDelegaete handleActionMsg:msg];
    }
}

- (void)error:(ActionData *)msg{
    if([msg.output objectForKey:MSG_KEY]){
        msg.discription = [msg.output objectForKey:MSG_KEY];
        NSLog(@"Error:%@",msg.discription);
    }
    msg.state = ErrorState;
    if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
        [self.aDelegaete handleActionMsg:msg];
    }
}

-(void)progressing:(ActionData *)msg{
    if([self.aDelegaete respondsToSelector:@selector(handleProgressMsg:)]){
        [self.aDelegaete handleProgressMsg:msg];
    }
}

@end
