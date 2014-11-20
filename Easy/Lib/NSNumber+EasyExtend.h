//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

#undef	__INT
#define __INT( __x )			[NSNumber numberWithInteger:(NSInteger)__x]

#undef	__UINT
#define __UINT( __x )			[NSNumber numberWithUnsignedInt:(NSUInteger)__x]

#undef	__FLOAT
#define	__FLOAT( __x )			[NSNumber numberWithFloat:(float)__x]

#undef	__DOUBLE
#define	__DOUBLE( __x )			[NSNumber numberWithDouble:(double)__x]

#undef	__BOOL
#define __BOOL( __x )			[NSNumber numberWithBool:(BOOL)__x]

#pragma mark -

@interface NSNumber(EasyExtend)

@property (nonatomic, readonly) NSDate *	dateValue;

- (NSString *)stringWithDateFormat:(NSString *)format;
- (NSString *)stringWithMillionFormat:(NSString *)format;
//获取安全字符串归零
-(NSString *)safeString;
//获取安全数字串归零
-(NSNumber *)safeNumber;
//获取安全Double归零
-(double)safeDouble;
-(BOOL)numberIsFloat;
-(BOOL)numberIsInt;
-(NSNumber *)increase:(NSNumber *)number;
-(NSNumber *)decrease:(NSNumber *)number;
@end
