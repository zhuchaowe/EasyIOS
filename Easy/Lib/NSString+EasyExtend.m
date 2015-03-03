//
//  NSString+EasyExtend.m
//  fastSign
//
//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "NSString+EasyExtend.h"
#import "NSData+EasyExtend.h"
#import "NSObject+EasyTypeConversion.h"
#import <AddressBook/AddressBook.h>
#import "pinyin.h"
@implementation NSString (EasyExtend)

//#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
//- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width
//{
//	CGSize size =  [self sizeWithFont:font
//			constrainedToSize:CGSizeMake(width, 999999.0f)
//				lineBreakMode:NSLineBreakByWordWrapping];
//    return size;
//}
//
//- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height
//{
//	return [self sizeWithFont:font
//			constrainedToSize:CGSizeMake(999999.0f, height)
//				lineBreakMode:NSLineBreakByWordWrapping];
//}
//#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

- (NSString *)MD5
{
	NSData * value;
	
	value = [NSData dataWithBytes:[self UTF8String] length:[self length]];
	value = [value MD5];
    
	if ( value )
	{
		char			tmp[16];
		unsigned char *	hex = (unsigned char *)malloc( 2048 + 1 );
		unsigned char *	bytes = (unsigned char *)[value bytes];
		unsigned long	length = [value length];
		
		hex[0] = '\0';
		
		for ( unsigned long i = 0; i < length; ++i )
		{
			sprintf( tmp, "%02X", bytes[i] );
			strcat( (char *)hex, tmp );
		}
		
		NSString * result = [NSString stringWithUTF8String:(const char *)hex];
		free( hex );
		return result;
	}
	else
	{
		return nil;
	}
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset
{
	if ( 0 == self.length )
		return nil;
	
	if ( from >= self.length )
		return nil;
    
	NSRange range = NSMakeRange( from, self.length - from );
	NSRange range2 = [self rangeOfCharacterFromSet:charset options:NSCaseInsensitiveSearch range:range];
    
	if ( NSNotFound == range2.location )
	{
		if ( endOffset )
		{
			*endOffset = range.location + range.length;
		}
		
		return [self substringWithRange:range];
	}
	else
	{
		if ( endOffset )
		{
			*endOffset = range2.location + range2.length;
		}
        
		return [self substringWithRange:NSMakeRange(from, range2.location - from)];
	}
}
- (NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSArray *)words
{
#if ! __has_feature(objc_arc)
    NSMutableArray *words = [[[NSMutableArray alloc] init] autorelease];
#else
    NSMutableArray *words = [[NSMutableArray alloc] init];
#endif
    
    const char *str = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    char *word;
    for (int i = 0; i < strlen(str);) {
        int len = 0;
        if (str[i] >= 0xFFFFFFFC) {
            len = 6;
        } else if (str[i] >= 0xFFFFFFF8) {
            len = 5;
        } else if (str[i] >= 0xFFFFFFF0) {
            len = 4;
        } else if (str[i] >= 0xFFFFFFE0) {
            len = 3;
        } else if (str[i] >= 0xFFFFFFC0) {
            len = 2;
        } else if (str[i] >= 0x00) {
            len = 1;
        }
        
        word = malloc(sizeof(char) * (len + 1));
        for (int j = 0; j < len; j++) {
            word[j] = str[j + i];
        }
        word[len] = '\0';
        i = i + len;
        
        NSString *oneWord = [NSString stringWithCString:word encoding:NSUTF8StringEncoding];
        free(word);
        [words addObject:oneWord];
    }
    
    return words;
}


- (NSString *)urldecode {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)urlencode {
	NSString *encUrl = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSUInteger len = [encUrl length];
	const char *c;
	c = [encUrl UTF8String];
	NSString *ret = @"";
	for(int i = 0; i < len; i++) {
		switch (*c) {
			case '~':
				ret = [ret stringByAppendingString:@"%7E"];
				break;
			case '/':
				ret = [ret stringByAppendingString:@"%2F"];
				break;
			case '\'':
				ret = [ret stringByAppendingString:@"%27"];
				break;
			case ';':
				ret = [ret stringByAppendingString:@"%3B"];
				break;
			case '?':
				ret = [ret stringByAppendingString:@"%3F"];
				break;
			case ':':
				ret = [ret stringByAppendingString:@"%3A"];
				break;
			case '@':
				ret = [ret stringByAppendingString:@"%40"];
				break;
			case '&':
				ret = [ret stringByAppendingString:@"%26"];
				break;
			case '=':
				ret = [ret stringByAppendingString:@"%3D"];
				break;
			case '+':
				ret = [ret stringByAppendingString:@"%2B"];
				break;
			case '$':
				ret = [ret stringByAppendingString:@"%24"];
				break;
			case ',':
				ret = [ret stringByAppendingString:@"%2C"];
				break;
			case '[':
				ret = [ret stringByAppendingString:@"%5B"];
				break;
			case ']':
				ret = [ret stringByAppendingString:@"%5D"];
				break;
			case '#':
				ret = [ret stringByAppendingString:@"%23"];
				break;
			case '!':
				ret = [ret stringByAppendingString:@"%21"];
				break;
			case '(':
				ret = [ret stringByAppendingString:@"%28"];
				break;
			case ')':
				ret = [ret stringByAppendingString:@"%29"];
				break;
			case '*':
				ret = [ret stringByAppendingString:@"%2A"];
				break;
			default:
				ret = [ret stringByAppendingFormat:@"%c", *c];
		}
		c++;
	}
    
	return ret;
}

-(NSString *)getOutOfTheNumber{
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:self.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        }
        else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    return strippedString;
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding
{
    NSURL * parsedURL = [NSURL URLWithString:self];
	NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString * query = [NSString queryStringFromDictionary:params encoding:encoding];
	return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict encoding:(BOOL)encoding
{
    NSMutableArray * pairs = [NSMutableArray array];
	for ( NSString * key in dict.allKeys )
	{
		NSString * value = [(NSObject *)[dict objectForKey:key] asNSString];
		NSString * urlEncoding = encoding ? [value urlencode] : value;
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
	}
	return [pairs componentsJoinedByString:@"&"];
}

-(NSString *)getNameFromAddressBookWithPhoneNum{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)    {
//       addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
//        //等待同意后向下执行
//        dispatch_semaphore_t sema = dispatch_semaphore_create(0);        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)                                                 {                                                     dispatch_semaphore_signal(sema);                                                 });
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);         dispatch(sema);
//    }else{
//        addressBook = ABAddressBookCreate();
//    }
    CFArrayRef records;
    if (addressBook) {
        // 获取通讯录中全部联系人
        records = ABAddressBookCopyArrayOfAllPeople(addressBook);
    }else{
        return nil;
    }
    // 遍历全部联系人，检查是否存在指定号码
    for (int i=0; i<CFArrayGetCount(records); i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(records, i);
        CFTypeRef items = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFArrayRef phoneNums = ABMultiValueCopyArrayOfAllValues(items);
        if (phoneNums) {
            for (int j=0; j<CFArrayGetCount(phoneNums); j++) {                NSString *phone = (NSString*)CFArrayGetValueAtIndex(phoneNums, j);
                phone = [phone getOutOfTheNumber];
                if ([phone isEqualToString:self]) {
                return (__bridge NSString*)ABRecordCopyCompositeName(record);
            }
            }
        }
    }
    return nil;
}


- (NSString *)firstLetter
{
    return [HTFirstLetter firstLetter:self];
}

- (NSString *)firstLetters
{
    return [HTFirstLetter firstLetters:self];
}

+(NSString *)jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}
+(NSString *)jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}
+(NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}
+(NSString *)jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }
    return value;
}


//获取安全字符串
-(NSString *)safeString{
    return self.isNotEmpty?self:@"";
}

#pragma mark Trimming Methods

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange rangeOfFirstWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]];
    if (rangeOfFirstWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringFromIndex:rangeOfFirstWantedCharacter.location];
}

- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters {
    return [self stringByTrimmingLeadingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange rangeOfLastWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]
                                                               options:NSBackwardsSearch];
    if (rangeOfLastWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringToIndex:rangeOfLastWantedCharacter.location+1]; // non-inclusive
}

- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters {
    return [self stringByTrimmingTrailingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}



@end


@implementation NSMutableString (EasyExtend)

+(NSMutableString *)stringFromResFile:(NSString *)name encoding:(NSStringEncoding)encode{
    return [NSMutableString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name] encoding:encode error:nil];
}


- (NSMutableStringAppendBlock)APPEND
{
	NSMutableStringAppendBlock block = ^ NSMutableString * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
		[self appendString:append];
		
		va_end( args );
        
		return self;
	};
	
	return [block copy];
}
@end