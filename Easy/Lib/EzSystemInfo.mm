//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//
#import "EzSystemInfo.h"

// ----------------------------------
// Source code
// ----------------------------------


#pragma mark -

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
const BOOL IOS8_OR_LATER = ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending );
const BOOL IOS7_OR_LATER = ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending );
const BOOL IOS6_OR_LATER = ( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending );
const BOOL IOS5_OR_LATER = ( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending );
const BOOL IOS4_OR_LATER = ( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending );
const BOOL IOS3_OR_LATER = ( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending );

const BOOL IOS7_OR_EARLIER = !IOS8_OR_LATER;
const BOOL IOS6_OR_EARLIER = !IOS7_OR_LATER;
const BOOL IOS5_OR_EARLIER = !IOS6_OR_LATER;
const BOOL IOS4_OR_EARLIER = !IOS5_OR_LATER;
const BOOL IOS3_OR_EARLIER = !IOS4_OR_LATER;

const BOOL IS_SCREEN_4_INCH = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO);
const BOOL IS_SCREEN_35_INCH = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO);
const BOOL IS_SCREEN_47_INCH = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO);
const BOOL IS_SCREEN_55_INCH = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO);
#else
const BOOL IOS8_OR_LATER = NO;
const BOOL IOS7_OR_LATER = NO;
const BOOL IOS6_OR_LATER = NO;
const BOOL IOS5_OR_LATER = NO;
const BOOL IOS4_OR_LATER = NO;
const BOOL IOS3_OR_LATER = NO;

const BOOL IOS7_OR_EARLIER = NO;
const BOOL IOS6_OR_EARLIER = NO;
const BOOL IOS5_OR_EARLIER = NO;
const BOOL IOS4_OR_EARLIER = NO;
const BOOL IOS3_OR_EARLIER = NO;

const BOOL IS_SCREEN_4_INCH = NO;
const BOOL IS_SCREEN_35_INCH = NO;

#endif
@implementation EzSystemInfo

DEF_SINGLETON( EzSystemInfo );

+ (NSString *)OSVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
	NSString * value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	if ( nil == value || 0 == value.length )
	{
		value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersion"];
	}
	return value;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appIdentifier
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	static NSString * __identifier = nil;
	if ( nil == __identifier )
	{
		__identifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
	}
	return __identifier;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return @"";
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appSchema
{
	return [self appSchema:nil];
}

+ (NSString *)appSchema:(NSString *)name
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	NSArray * array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
	for ( NSDictionary * dict in array )
	{
		if ( name )
		{
			NSString * URLName = [dict objectForKey:@"CFBundleURLName"];
			if ( nil == URLName )
			{
				continue;
			}

			if ( NO == [URLName isEqualToString:name] )
			{
				continue;
			}
		}

		NSArray * URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
		if ( nil == URLSchemes || 0 == URLSchemes.count )
		{
			continue;
		}

		NSString * schema = [URLSchemes objectAtIndex:0];
		if ( schema && schema.length )
		{
			return schema;
		}
	}

	return nil;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)deviceModel
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [UIDevice currentDevice].model;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}


#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
static const char * __jb_app = NULL;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

+ (BOOL)isJailBroken NS_AVAILABLE_IOS(4_0)
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	static const char * __jb_apps[] =
	{
		"/Application/Cydia.app", 
		"/Application/limera1n.app", 
		"/Application/greenpois0n.app", 
		"/Application/blackra1n.app",
		"/Application/blacksn0w.app",
		"/Application/redsn0w.app",
		NULL
	};

	__jb_app = NULL;

	// method 1
    for ( int i = 0; __jb_apps[i]; ++i )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] )
        {
			__jb_app = __jb_apps[i];
			return YES;
        }
    }
	
    // method 2
	if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] )
	{
		return YES;
	}
	
	// method 3
	if ( 0 == system("ls") )
	{
		return YES;
	}
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
    return NO;
}

+ (NSString *)jailBreaker NS_AVAILABLE_IOS(4_0)
{
#if (TARGET_OS_IPHONE)
	if ( __jb_app )
	{
		return [NSString stringWithUTF8String:__jb_app];
	}
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

	return @"";
}

+ (BOOL)isDevicePhone
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	NSString * deviceType = [UIDevice currentDevice].model;
	
	if ( [deviceType rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].length > 0 ||
		[deviceType rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].length > 0 ||
		[deviceType rangeOfString:@"iTouch" options:NSCaseInsensitiveSearch].length > 0 )
	{
		return YES;
	}
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	return NO;
}

+ (BOOL)isDevicePad
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	NSString * deviceType = [UIDevice currentDevice].model;
	
	if ( [deviceType rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0 )
	{
		return YES;
	}
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	return NO;
}

+ (BOOL)requiresPhoneOS
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [[[NSBundle mainBundle].infoDictionary objectForKey:@"LSRequiresIPhoneOS"] boolValue];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPhone
{
	if ( [self isPhone35] || [self isPhoneRetina35] || [self isPhoneRetina4] )
	{
		return YES;
	}
	
	return NO;
}

+ (BOOL)isPhone35
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	if ( [self isDevicePad] )
	{
		if ( [self requiresPhoneOS] && [self isPad] )
		{
			return YES;
		}

		return NO;
	}
	else
	{
		return [EzSystemInfo isScreenSize:CGSizeMake(320, 480)];
	}
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPhoneRetina35
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	if ( [self isDevicePad] )
	{
		if ( [self requiresPhoneOS] && [self isPadRetina] )
		{
			return YES;
		}

		return NO;
	}
	else
	{
		return [EzSystemInfo isScreenSize:CGSizeMake(640, 960)];
	}
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPhoneRetina4
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	if ( [self isDevicePad] )
	{
		return NO;
	}
	else
	{
		return [EzSystemInfo isScreenSize:CGSizeMake(640, 1136)];
	}
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPad
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [EzSystemInfo isScreenSize:CGSizeMake(768, 1024)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPadRetina
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [EzSystemInfo isScreenSize:CGSizeMake(1536, 2048)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isScreenSize:(CGSize)size
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	if ( [UIScreen instancesRespondToSelector:@selector(currentMode)] )
	{
		CGSize size2 = CGSizeMake( size.height, size.width );
		CGSize screenSize = [UIScreen mainScreen].currentMode.size;
		
		if ( CGSizeEqualToSize(size, screenSize) || CGSizeEqualToSize(size2, screenSize) )
		{
			return YES;
		}
	}

	return NO;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

@end
