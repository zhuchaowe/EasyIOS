
//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EzCacheProtocol<NSObject>

- (BOOL)hasObjectForKey:(id)key;
- (id)objectForKey:(id)key;
- (void)setObject:(id)object forKey:(id)key;
- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id)key;

@end
