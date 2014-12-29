//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "NSNumber+EasyExtend.h"
#import "NSDate+EasyExtend.h"
#import "NSString+EasyExtend.h"
// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSNumber(EasyExtend)

@dynamic dateValue;

- (NSDate *)dateValue
{
	return [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
	return [[NSDate dateWithTimeIntervalSince1970:[self doubleValue]] stringWithDateFormat:format];
}


- (BOOL)numberIsInt{
    if([self floatValue] == [self intValue]){
        return YES;
    }else{
        return NO;
    }
}

-(NSNumber *)increase:(NSNumber *)number{
    return @(self.integerValue + number.integerValue);
}

-(NSNumber *)decrease:(NSNumber *)number{
    if (self.integerValue == 1) {
        return self;
    }else{
        return @(self.integerValue - number.integerValue);
    }
}

- (BOOL)numberIsFloat{
    return ![self numberIsInt];
}

- (NSString *)stringWithMillionFormat:(NSString *)format{
    double numberValue= [self safeDouble];
    NSString *string = nil;
    if(numberValue > 9999){
        numberValue=numberValue/10000;
        if(numberValue >9999){
            numberValue=numberValue/10000;
            string = [NSString stringWithFormat:format,numberValue];
            string = [NSString stringWithFormat:@"%@亿",string];
        }else{
            string = [NSString stringWithFormat:format,numberValue];
            string = [NSString stringWithFormat:@"%@万",string];
        }
    }
    else{
        string =[NSString stringWithFormat:format,numberValue];
    }
    return [string safeString];
}

//获取安全字符串归零
-(NSString *)safeString{
    return self.isNotEmpty?[NSString stringWithFormat:@"%@",self]:@"";
}

//获取安全数字串归零
-(NSNumber *)safeNumber{
    return __DOUBLE([self safeDouble]);
}

//获取安全Double归零
-(double)safeDouble{
    NSNumber *object = [self isKindOfClass:[NSNull class]] ?  __DOUBLE(0.0): self;
    double number = object !=nil ? [object doubleValue] :0;
    return number;
}
@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSNumber_BeeExtension )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
