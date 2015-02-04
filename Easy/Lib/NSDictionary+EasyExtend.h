//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//
#import <Foundation/Foundation.h>

#pragma mark -

typedef NSDictionary *	(^NSDictionaryAppendBlock)( NSString * key, id value );

#pragma mark -

#undef	CONVERT_PROPERTY_CLASS
#define	CONVERT_PROPERTY_CLASS( __name, __class ) \
		+ (Class)convertPropertyClassFor_##__name \
		{ \
			return NSClassFromString( [NSString stringWithUTF8String:#__class] ); \
		}

#pragma mark -

@interface NSDictionary(EasyExtend)

@property (nonatomic, readonly) NSDictionaryAppendBlock	APPEND;

- (id)objectOfAny:(NSArray *)array;
- (NSString *)stringOfAny:(NSArray *)array;

- (id)objectAtPath:(NSString *)path;
- (id)objectAtPath:(NSString *)path otherwise:(NSObject *)other;

- (id)objectAtPath:(NSString *)path separator:(NSString *)separator;
- (id)objectAtPath:(NSString *)path otherwise:(NSObject *)other separator:(NSString *)separator;

- (id)objectAtPath:(NSString *)path withClass:(Class)clazz;
- (id)objectAtPath:(NSString *)path withClass:(Class)clazz otherwise:(NSObject *)other;

- (BOOL)boolAtPath:(NSString *)path;
- (BOOL)boolAtPath:(NSString *)path otherwise:(BOOL)other;

- (NSNumber *)numberAtPath:(NSString *)path;
- (NSNumber *)numberAtPath:(NSString *)path otherwise:(NSNumber *)other;

- (NSString *)stringAtPath:(NSString *)path;
- (NSString *)stringAtPath:(NSString *)path otherwise:(NSString *)other;

- (NSArray *)arrayAtPath:(NSString *)path;
- (NSArray *)arrayAtPath:(NSString *)path otherwise:(NSArray *)other;

- (NSArray *)arrayAtPath:(NSString *)path withClass:(Class)clazz;
- (NSArray *)arrayAtPath:(NSString *)path withClass:(Class)clazz otherwise:(NSArray *)other;

- (NSMutableArray *)mutableArrayAtPath:(NSString *)path;
- (NSMutableArray *)mutableArrayAtPath:(NSString *)path otherwise:(NSMutableArray *)other;

- (NSDictionary *)dictAtPath:(NSString *)path;
- (NSDictionary *)dictAtPath:(NSString *)path otherwise:(NSDictionary *)other;

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path;
- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path otherwise:(NSMutableDictionary *)other;
- (NSDictionary *)each:(void (^)(id key, id value))block;
- (NSDictionary *)eachWithStop:(void (^)(id key, id value, BOOL *stop))block;
- (NSDictionary *)eachKey:(void (^)(id key))block;
- (NSDictionary *)eachValue:(void (^)(id value))block;
- (NSString *)joinToPath;
@end

#pragma mark -

@interface NSMutableDictionary(BeeExtension)

@property (nonatomic, readonly) NSDictionaryAppendBlock	APPEND;

+ (NSMutableDictionary *)nonRetainingDictionary;			// copy from Three20

- (NSString *)stringOfAny:(NSArray *)array removeAll:(BOOL)flag;

- (BOOL)setObject:(NSObject *)obj atPath:(NSString *)path;
- (BOOL)setObject:(NSObject *)obj atPath:(NSString *)path separator:(NSString *)separator;

- (BOOL)setKeyValues:(id)first, ...;

+ (NSMutableDictionary *)keyValues:(id)first, ...;

@end
