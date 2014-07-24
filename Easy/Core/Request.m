//
//  Request.m
//  NewEasy
//
//  Created by 朱潮 on 14-7-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Request.h"
#import <objc/runtime.h>
@implementation Request

+(id)Request{
    return [[self alloc]initRequest];
}

-(id)initRequest{
    self = [self init];
    if(self){
        [self loadRequest];
    }
    return self;
}

-(void)loadRequest{
    self.HOST = @"";
    self.PATH = @"";
    self.METHOD = @"GET";
}

+(NSString *)requestKey{
    return NSStringFromClass([self class]);
}
-(NSString *)requestKey{
    return NSStringFromClass([self class]);
}

-(NSMutableDictionary *)requestParams{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *key in [self getPropertyList:[self class]]) {
        if(![[self valueForKey:key] isKindOfClass:[NSNull class]] && [self valueForKey:key] !=nil){
                [dict setObject:[self valueForKey:key] forKey:key];
        }
    }
    return dict;
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
@end
