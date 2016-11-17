//
//  NSData+EasyExtend.h
//  fastSign
//
//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSData (EasyExtend)

@property (nonatomic, readonly) NSData *	MD5;
@property (nonatomic, readonly) NSString *	MD5String;

+ (NSData *)fromResource:(NSString *)resName;

@end
