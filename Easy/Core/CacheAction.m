//
//  CacheAction.m
//  fastSign
//
//  Created by EasyIOS on 14-4-13.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "CacheAction.h"

@implementation CacheAction
+ (CacheAction *)sharedInstance
{
    static dispatch_once_t pred;
    static CacheAction *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] initWithCache];
    });
    
    return sharedInstance;
}

@end
