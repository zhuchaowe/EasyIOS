//
//  TimeTool.m
//  fastSign
//
//  Created by 朱潮 on 14-5-17.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "TimeTool.h"

@implementation TimeTool

+ (TimeTool *)sharedInstance
{
    static dispatch_once_t pred;
    static TimeTool *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


+ (NSString *)getTimeDiffString:(NSTimeInterval)timestamp {
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDate *todate = [NSDate dateWithTimeIntervalSince1970:timestamp];
	NSDate *today = [NSDate date]; //当前时间
	unsigned int unitFlag = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
	NSDateComponents *gap = [cal components:unitFlag fromDate:today toDate:todate options:0]; //计算时间差
    
	if (ABS([gap day]) > 0) {
		return [NSString stringWithFormat:@"%ld天前", (long)(ABS([gap day]))];
	}
	else if (ABS([gap hour]) > 0) {
		return [NSString stringWithFormat:@"%ld小时前", (long)(ABS([gap hour]))];
	}
	else {
		return [NSString stringWithFormat:@"%ld分钟前",  (long)(ABS([gap minute]))];
	}
}
+(NSTimeInterval)formatTimeSinceNow:(NSTimeInterval)timestamp{
    NSDate *time = [NSDate dateWithTimeIntervalSinceNow:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
	NSString *thisDayMin = [dateFormatter stringFromDate:time];
    
    return [[dateFormatter dateFromString:thisDayMin] timeIntervalSince1970];
}

+ (NSString *)formatDateSinceNow:(NSTimeInterval)timestamp formatWith:(NSString *)format{
    NSDate *time = [NSDate dateWithTimeIntervalSinceNow:timestamp];
    return [self formatDate:time formatWith:format];
}

+ (NSString *)formatTime:(NSTimeInterval)timestamp formatWith:(NSString *)format{
    
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:timestamp];
    if(time == 0){
        return @"";
    }else{
        return [self formatDate:time formatWith:format];
    }
}

//format :yyyy-MM-dd
+ (NSString *)formatDate:(NSDate *)date formatWith:(NSString *)format{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:format];
	NSString *currentDateStr = [dateFormatter stringFromDate:date];
	return currentDateStr;
}

/**
 *	获取时间的key 按星期  e.q "从 2013-08-05 至 2013-08-11"
 *
 *	@param	timestamp
 *
 *	@return
 */
+ (NSString *)getWeekKeyString:(NSTimeInterval)timestamp {
	NSTimeInterval timestampStart = [self getFirstDayOfWeek:timestamp];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestampStart];
	NSString *timeStart = [self formatDate:date formatWith:@"yyyy-MM-dd"];
    
	NSString *timeEnd = [self formatDate:[date dateByAddingTimeInterval:3600 * 24 * 6] formatWith:@"yyyy-MM-dd"];
    
	return [NSString stringWithFormat:@"From %@ to %@", timeStart, timeEnd];
}

+ (NSString *)getFirstDayForWeekKeyString:(NSTimeInterval)timestamp {
	NSTimeInterval timestampStart = [self getFirstDayOfWeek:timestamp];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestampStart];
	NSString *timeStart = [self formatDate:date formatWith:@"yyyy-MM-dd"];
    
	return timeStart;
}

+ (NSString *)getMonthKeyStringByOffset:(NSInteger)month {
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *comps = [cal
	                           components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                               fromDate:[NSDate date]];
    
	comps.month = comps.month + month;
	if (comps.month > 12) {
		comps.year = comps.year + 1;
		comps.month =  comps.month - 12;
	}
	else if (comps.month < 1) {
		comps.year = comps.year - 1;
		comps.month = comps.month + 12;
	}
    
	NSDate *date = [cal dateFromComponents:comps];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM"];
	NSString *currentDateStr = [dateFormatter stringFromDate:date];
	return currentDateStr;
}

+ (NSInteger)getTotalDayInMonth:(NSTimeInterval)timestamp{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
    return range.length;
}


+ (NSTimeInterval)getFirstDayOfQuarter:(NSTimeInterval)timestamp {
	NSDate *now = [NSDate dateWithTimeIntervalSince1970:timestamp];
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *comps = [cal
	                           components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                               fromDate:now];
	if (comps.month <= 3) {
		comps.month =  1;
	}
	else if (comps.month <= 6) {
		comps.month =  4;
	}
	else if (comps.month <= 9) {
		comps.month =  7;
	}
	else if (comps.month <= 12) {
		comps.month =  10;
	}
    
	comps.day = 1;
	NSDate *firstDay = [cal dateFromComponents:comps];
	return [firstDay timeIntervalSince1970];
}

+ (NSTimeInterval)getFirstDayOfWeek:(NSTimeInterval)timestamp {
	NSDate *now = [NSDate dateWithTimeIntervalSince1970:timestamp];
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *comps = [cal
	                           components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit
                               fromDate:now];
	NSLog(@"%ld,%ld,%ld,%ld", (long)comps.year, (long)comps.month, (long)comps.weekOfMonth, (long)comps.weekday);
	if (comps.weekday < 2) {
		comps.weekOfMonth = comps.weekOfMonth - 1;
	}
	comps.weekday = 2;
	//   NSLog(@"%d,%d,%d,%d",comps.year,comps.month,comps.week,comps.weekday);
	NSDate *firstDay = [cal dateFromComponents:comps];
	return [firstDay timeIntervalSince1970];
}


+ (NSTimeInterval)getFirstDayOfMonth:(NSTimeInterval)timestamp {
	NSDate *now = [NSDate dateWithTimeIntervalSince1970:timestamp];
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *comps = [cal
	                           components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                               fromDate:now];
	comps.day = 1;
	NSDate *firstDay = [cal dateFromComponents:comps];
	return [firstDay timeIntervalSince1970];
}

+ (NSTimeInterval)getFirstDayOfLastMonth:(NSTimeInterval)timestamp{
	NSDate *now = [NSDate dateWithTimeIntervalSince1970:timestamp];
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *comps = [cal
	                           components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                               fromDate:now];
    if(comps.month - 1 == 0 ){
        comps.month = 12;
        comps.year = comps.year -1;
    }else{
        comps.month = comps.month - 1;
    }
	comps.day = 1;
	NSDate *firstDay = [cal dateFromComponents:comps];
	return [firstDay timeIntervalSince1970];
}



@end
