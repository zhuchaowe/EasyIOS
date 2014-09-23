//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "NSDate+EasyExtend.h"
#import "NSNumber+EasyExtend.h"

const NSInteger SECOND = 1;
const NSInteger MINUTE = 60 * SECOND;
const NSInteger HOUR = 60 * MINUTE;
const NSInteger DAY = 24 * HOUR;
const NSInteger MONTH = 30 * DAY;
const NSInteger YEAR = 12 * MONTH;


@implementation NSDate(EasyExtend)

@dynamic year;
@dynamic month;
@dynamic day;
@dynamic hour;
@dynamic minute;
@dynamic second;
@dynamic weekday;

- (NSInteger)year
{
	return [[NSCalendar currentCalendar] components:NSYearCalendarUnit
										   fromDate:self].year;
}

- (NSInteger)month
{
	return [[NSCalendar currentCalendar] components:NSMonthCalendarUnit
										   fromDate:self].month;
}

- (NSInteger)day
{
	return [[NSCalendar currentCalendar] components:NSDayCalendarUnit
										   fromDate:self].day;
}

- (NSInteger)hour
{
	return [[NSCalendar currentCalendar] components:NSHourCalendarUnit
										   fromDate:self].hour;
}

- (NSInteger)minute
{
	return [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit
										   fromDate:self].minute;
}

- (NSInteger)second
{
	return [[NSCalendar currentCalendar] components:NSSecondCalendarUnit
										   fromDate:self].second;
}

- (NSInteger)weekday
{
	return [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit
										   fromDate:self].weekday;
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:format];
	return [dateFormatter stringFromDate:self];
}

- (NSString *)timeAgo
{
	NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
	
	if (delta < 1 * MINUTE)
	{
		return @"刚刚";
	}
	else if (delta < 2 * MINUTE)
	{
		return @"1分钟前";
	}
	else if (delta < 45 * MINUTE)
	{
		int minutes = floor((double)delta/MINUTE);
		return [NSString stringWithFormat:@"%d分钟前", minutes];
	}
	else if (delta < 90 * MINUTE)
	{
		return @"1小时前";
	}
	else if (delta < 24 * HOUR)
	{
		int hours = floor((double)delta/HOUR);
		return [NSString stringWithFormat:@"%d小时前", hours];
	}
	else if (delta < 48 * HOUR)
	{
		return @"昨天";
	}
	else if (delta < 30 * DAY)
	{
		int days = floor((double)delta/DAY);
		return [NSString stringWithFormat:@"%d天前", days];
	}
	else if (delta < 12 * MONTH)
	{
		int months = floor((double)delta/MONTH);
		return months <= 1 ? @"1个月前" : [NSString stringWithFormat:@"%d个月前", months];
	}

	int years = floor((double)delta/MONTH/12.0);
	return years <= 1 ? @"1年前" : [NSString stringWithFormat:@"%d年前", years];
}

- (NSString *)timeLeft
{
	long int delta = lround( [self timeIntervalSinceDate:[NSDate date]] );

    NSMutableString * result = [NSMutableString string];
    
    if ( delta >= YEAR )
    {
		NSInteger years = ( delta / YEAR );
        [result appendFormat:@"%ld年", (long)years];
        delta -= years * YEAR ;
    }
    
	if ( delta >= MONTH )
	{
        NSInteger months = ( delta / MONTH );
        [result appendFormat:@"%ld月", (long)months];
        delta -= months * MONTH ;
	}
    
    if ( delta >= DAY )
    {
        NSInteger days = ( delta / DAY );
        [result appendFormat:@"%ld天", (long)days];
        delta -= days * DAY ;
    }
    
    if ( delta >= HOUR )
    {
        NSInteger hours = ( delta / HOUR );
        [result appendFormat:@"%ld小时", (long)hours];
        delta -= hours * HOUR ;
    }
    
    if ( delta >= MINUTE )
    {
        NSInteger minutes = ( delta / MINUTE );
        [result appendFormat:@"%ld分钟", (long)minutes];
        delta -= minutes * MINUTE ;
    }

	NSInteger seconds = ( delta / SECOND );
	[result appendFormat:@"%ld秒", (long)seconds];

	return result;
}

+ (long long)timeStamp
{
	return (long long)[[NSDate date] timeIntervalSince1970];
}

+ (NSDate *)dateWithString:(NSString *)string format:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:string];
}

+ (NSDate *)now
{
	return [NSDate date];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSDate_BeeExtension )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
