//
//  ActionData.m
//  fastSign
//
//  Created by EasyIOS on 14-4-11.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "ActionData.h"

@implementation ActionData


+(id)Data{
    
    return [[[self class] alloc] init];
}
- (id)init
{
    self = [super init];
    self.state = SendingState;
    self.output = nil;
    self.key = @"";
    self.discription = @"";
    self.progress = 0.0f;
    self.files = [NSDictionary dictionary];
	return self;
}

- (BOOL)validate:(NSString *)key{
   return [self.key isEqualToString:key];
}

- (BOOL)succeed
{
    if(self.output == nil){
        return NO;
    }
	return SuccessState == _state ? YES : NO;
}
- (BOOL)failed
{
	return FailState == _state || ErrorState == _state ? YES : NO;
}
- (BOOL)sending
{
	return SendingState == _state ? YES : NO;
}
@end
