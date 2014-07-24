//
//  Request.m
//  NewEasy
//
//  Created by 朱潮 on 14-7-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Request.h"
#import "JastorRuntimeHelper.h"
@implementation Request

+(id)Request{
    return [[self alloc]initRequest];
}

-(id)initRequest{
    self = [self init];
    if(self){
        self.HOST = @"";
        self.PATH = @"";
        [self loadRequest];
    }
    return self;
}

-(void)loadRequest{
    
}

-(NSMutableDictionary *)requestParams{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
        if(![key isEqualToString:@"HOST"] && ![key isEqualToString:@"PATH"] && ![[self valueForKey:key] isKindOfClass:[NSNull class]] && [self valueForKey:key] !=nil){
                [dict setObject:[self valueForKey:key] forKey:key];
        }
    }
    return dict;
}
@end
