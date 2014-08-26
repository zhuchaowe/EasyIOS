//
//  Model.h
//  fastSign
//
//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+EasyExtend.h"
#import "JSONModelLib.h"
@interface Model : JSONModel
+(id)Model;
-(void)loadModel;
@end
