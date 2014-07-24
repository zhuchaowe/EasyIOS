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

+(id)Request;
-(id)initRequest;
-(void)loadRequest;
-(NSDictionary *)requestParams;
@end
