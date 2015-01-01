//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "EzSingleton.h"

extern const BOOL IOS8_OR_LATER;
extern const BOOL IOS7_OR_LATER;
extern const BOOL IOS6_OR_LATER;
extern const BOOL IOS5_OR_LATER;
extern const BOOL IOS4_OR_LATER;
extern const BOOL IOS3_OR_LATER;

extern const BOOL IOS7_OR_EARLIER;
extern const BOOL IOS6_OR_EARLIER;
extern const BOOL IOS5_OR_EARLIER;
extern const BOOL IOS4_OR_EARLIER;
extern const BOOL IOS3_OR_EARLIER;

extern const BOOL IS_SCREEN_4_INCH;
extern const BOOL IS_SCREEN_35_INCH;
extern const BOOL IS_SCREEN_47_INCH;
extern const BOOL IS_SCREEN_55_INCH;
@interface EzSystemInfo : NSObject

AS_SINGLETON( EzSystemInfo )

+ (NSString *)OSVersion;
+ (NSString *)appVersion;
+ (NSString *)appIdentifier;
+ (NSString *)appSchema;
+ (NSString *)appSchema:(NSString *)name;
+ (NSString *)deviceModel;

+ (BOOL)isJailBroken		NS_AVAILABLE_IOS(4_0);
+ (NSString *)jailBreaker	NS_AVAILABLE_IOS(4_0);

+ (BOOL)isDevicePhone;
+ (BOOL)isDevicePad;

+ (BOOL)requiresPhoneOS;

+ (BOOL)isPhone;
+ (BOOL)isPhone35;
+ (BOOL)isPhoneRetina35;
+ (BOOL)isPhoneRetina4;
+ (BOOL)isPad;
+ (BOOL)isPadRetina;
+ (BOOL)isScreenSize:(CGSize)size;

@end
