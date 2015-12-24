//
//  Request.m
//  NewEasy
//
//  Created by 朱潮 on 14-7-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Request.h"
#import <objc/runtime.h>

NSString * const RequestStateSuccess = @"RequestDidSuccess";
NSString * const RequestStateFailed = @"RequestDidFailed";
NSString * const RequestStateSending = @"RequestDidSending";
NSString * const RequestStateError = @"RequestDidError";
NSString * const RequestStateCancle = @"RequestDidCancle";


@implementation Request

+(id)Request{
    return [[self alloc]initRequest];
}

+(id)RequestWithBlock:(EZVoidBlock)voidBlock{
    return [[self alloc]initRequestWithBlock:voidBlock];
}

-(id)initRequest{
    self = [self init];
    if(self){
        [self loadRequest];
    }
    return self;
}

-(id)initRequestWithBlock:(EZVoidBlock)voidBlock{
    self = [self init];
    if(self){
        self.requestInActiveBlock = voidBlock;
        [self loadRequest];
    }
    return self;
}

-(void)loadRequest{
    self.output = nil;
    self.message = @"";
    self.progress = nil;
    self.freezable = NO;
    self.SCHEME = @"";
    self.HOST = @"";
    self.PATH = @"";
    self.METHOD = @"GET";
    self.needCheckCode = YES;
    self.params = [NSMutableDictionary dictionary];
    self.isFirstRequest = YES;
    [self loadActive];
}

- (void)loadActive{
    self.requestNeedActive = NO;
    @weakify(self);
    [[RACObserve(self,requestNeedActive)
      filter:^BOOL(NSNumber *active) {
          return [active boolValue];
      }]
     subscribeNext:^(NSNumber *active) {
         @strongify(self);
         if (self.requestInActiveBlock) {
             self.requestInActiveBlock();
         }
         self.requestNeedActive = NO;
     }];
}

- (BOOL)succeed
{
    if(self.output == nil){
        return NO;
    }
    return RequestStateSuccess == _state ? YES : NO;
}
- (BOOL)failed
{
    return RequestStateFailed == _state || RequestStateError == _state ? YES : NO;
}
- (BOOL)sending
{
    return RequestStateSending == _state ? YES : NO;
}
- (BOOL)cancled{
    return RequestStateCancle == _state ? YES : NO;
}

- (void)cancle{
    if(self.op.isNotEmpty && self.op.state == NSURLSessionTaskStateRunning){
        [self.op cancel];
        self.state = RequestStateCancle;
    }
}

+(NSString *)requestKey{
    return NSStringFromClass([self class]);
}
-(NSString *)requestKey{
    return NSStringFromClass([self class]);
}

-(NSMutableDictionary *)requestParams{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *propertyList = [self getPropertyList:[self class]];
    [propertyList each:^(NSString *key) {
        NSObject *object = [self valueForKey:key];
        if(object.isNotEmpty){
            [dict setObject:[self valueForKey:key] forKey:key];
        }
    }];
    if (self.params.isNotEmpty) {
        [dict addEntriesFromDictionary:self.params];
    }
    return dict;
}

-(NSString *)appendPathInfo{
    __block NSString *pathInfo = self.pathInfo;
    if(pathInfo.isNotEmpty){
        [self.requestParams enumerateKeysAndObjectsUsingBlock:^(NSString* key, id value, BOOL *stop) {
            NSString *par = [NSString stringWithFormat:@"(\\{%@\\})",key];
            NSString *str = [NSString stringWithFormat:@"%@",value];
            
            pathInfo = [[[NSRegularExpression alloc] initWithPattern:par options:0 error:nil] stringByReplacingMatchesInString:pathInfo options:0 range:NSMakeRange(0, pathInfo.length) withTemplate:str];
        }];
    }
    return pathInfo;
}

-(NSString *)pathInfo{
    return nil;
}

-(NSArray *)getPropertyList:(Class)klass{
    NSMutableArray *propertyNamesArray = [NSMutableArray array];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(klass, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNamesArray addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNamesArray;
}

-(NSString *)cacheKey{
    NSAssert(self.url.isNotEmpty, @"url is empty");
    if([self.METHOD isEqualToString:@"GET"]){
        return self.url.absoluteString.MD5;
    }else if(self.requestParams.isNotEmpty){
        return [NSString stringWithFormat:@"%@%@",self.url,[self.requestParams joinToPath]].MD5;
    }else{
        return [NSString stringWithFormat:@"%@",self.url].MD5;
    }
}
@end
