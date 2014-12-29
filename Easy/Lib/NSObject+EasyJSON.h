//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//
 
#import <Foundation/Foundation.h>

#pragma mark -

@interface NSObject(EasyJSON)

+ (id)objectsFromArray:(id)arr;
+ (id)objectsFromAny:(id)any;

+ (id)objectFromDictionary:(id)dict;
+ (id)objectFromString:(id)str;
+ (id)objectFromData:(id)data;
+ (id)objectFromAny:(id)any;

- (id)objectToDictionary;
- (id)objectToString;
- (id)objectToData;
- (id)objectZerolize;

- (id)objectToDictionaryUntilRootClass:(Class)rootClass;
- (id)objectToStringUntilRootClass:(Class)rootClass;
- (id)objectToDataUntilRootClass:(Class)rootClass;
- (id)objectZerolizeUntilRootClass:(Class)rootClass;

- (id)serializeObject;
+ (id)unserializeObject:(id)obj;
-(BOOL)isNotEmpty;

@end
