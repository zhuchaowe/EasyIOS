//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
        - (__class *)sharedInstance; \
        + (__class *)sharedInstance;
#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
        - (__class *)sharedInstance \
        { \
            return [__class sharedInstance]; \
        } \
        + (__class *)sharedInstance \
        { \
            static dispatch_once_t once; \
            static __class * __singleton__; \
            dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
            return __singleton__; \
        }

@interface BeeSingleton : NSObject
@end
