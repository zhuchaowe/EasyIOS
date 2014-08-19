//
//  Model.m
//  fastSign
//
//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Model.h"

@implementation Model

+(id)ModelWithTable{
    return [[self alloc]initWithTable];
}

+(id)Model{
    return [[self alloc]initModel];
}

-(id)initWithTable{
    self = [self initModel];
    if(self){
        [self createTable];
    }
    return self;
}

-(id)initModel{
    self = [super init];
    if(self){
        
    }
    return self;
}

@end
