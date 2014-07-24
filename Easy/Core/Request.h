//
//  Request.h
//  NewEasy
//
//  Created by 朱潮 on 14-7-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Request : NSObject
@property(nonatomic,retain)NSString *HOST;
@property(nonatomic,retain)NSString *PATH;
@property(nonatomic,retain)NSString *METHOD;
+(id)Request;
-(void)loadRequest;
-(NSString *)requestKey;
+(NSString *)requestKey;
-(NSDictionary *)requestParams;
@end
