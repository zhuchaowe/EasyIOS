//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//
#import "Easy.h"
#import "EzCacheProtocol.h"
#pragma mark -

#define AS_USERDEFAULT( __name )	AS_STATIC_PROPERTY( __name )
#define DEF_USERDEFAULT( __name )	DEF_STATIC_PROPERTY3( __name, @"userdefault", [self description] )

#pragma mark -

@interface EzUserDefaults : NSObject<EzCacheProtocol>

AS_SINGLETON( EzUserDefaults )

@end
