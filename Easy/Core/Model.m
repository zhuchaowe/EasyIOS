//
//  Model.m
//  fastSign
//
//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Model.h"

@implementation Model

-(instancetype)init{
    self = [super init];
    if(self){
        [self loadModel];
    }
    return self;
}

+(id)Model{
    return [[self alloc]init];
}

-(void)loadModel{

}

@end
