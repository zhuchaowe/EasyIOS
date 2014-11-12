//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "NSArray+EasyExtend.h"
#import "pinyin.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSArray(EasyExtend)

@dynamic APPEND;
@dynamic mutableArray;

- (NSArrayAppendBlock)APPEND
{
	NSArrayAppendBlock block = ^ NSMutableArray * ( id obj )
	{
		NSMutableArray * array = [NSMutableArray arrayWithArray:self];
		[array addObject:obj];
		return array;
	};
	
	return [block copy];
}

- (NSArray *)head:(NSUInteger)count
{
	if ( [self count] < count )
	{
		return self;
	}
	else
	{
		NSMutableArray * tempFeeds = [NSMutableArray array];
		for ( NSObject * elem in self )
		{
			[tempFeeds addObject:elem];
			if ( [tempFeeds count] >= count )
				break;
		}
		return tempFeeds;
	}
}

- (NSArray *)tail:(NSUInteger)count
{	
//	if ( [self count] < count )
//	{
//		return self;
//	}
//	else
//	{
//        NSMutableArray * tempFeeds = [NSMutableArray array];
//		
//        for ( NSUInteger i = 0; i < count; i++ )
//		{
//            [tempFeeds insertObject:[self objectAtIndex:[self count] - i] atIndex:0];
//        }
//
//		return tempFeeds;
//	}

// thansk @lancy, changed: NSArray tail: count

	NSRange range = NSMakeRange( self.count - count, count );
	return [self subarrayWithRange:range];
}

-(id)objectAtIndexPath:(NSIndexPath *)indexPath{
    return [[self safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
}
- (id)safeObjectAtIndex:(NSInteger)index
{
	if ( index < 0 )
		return nil;
	
	if ( index >= self.count )
		return nil;

	return [self objectAtIndex:index];
}

- (NSArray *)safeSubarrayWithRange:(NSRange)range
{
	if ( 0 == self.count )
		return nil;

	if ( range.location >= self.count )
		return nil;

	if ( range.location + range.length >= self.count )
		return nil;
	
	return [self subarrayWithRange:NSMakeRange(range.location, range.length)];
}

- (NSMutableArray *)mutableArray
{
	return [NSMutableArray arrayWithArray:self];
}

- (NSString *)join:(NSString *)delimiter
{
	if ( 0 == self.count )
	{
		return @"";
	}
	else if ( 1 == self.count )
	{
		return [NSString stringWithFormat:@"%@",[self objectAtIndex:0]];
	}
	else
	{
		NSMutableString * result = [NSMutableString string];
		
		for ( NSUInteger i = 0; i < self.count; ++i )
		{
            [result appendString:[NSString stringWithFormat:@"%@",[self objectAtIndex:i]]];
			
			
			if ( i + 1 < self.count )
			{
				[result appendString:delimiter];
			}
		}
		
		return result;
	}
}


-(NSString *)stringByWords{
    NSMutableString *str = [NSMutableString string];
    for (NSString *w in self) {
        [str appendString:w];
    }
    return (NSString *)str;
}

- (NSDictionary *)sortedArrayUsingFirstLetter
{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    const char *letterPoint = NULL;
    NSString *firstLetter = nil;
    for (NSString *str in self) {
        
        //检查 str 是不是 NSString 类型
        if (![str isKindOfClass:[NSString class]]) {
            assert(@"object in array is not NSString");
            continue;
        }
        
        letterPoint = [str UTF8String];
        
        //如果开头不是大小写字母则读取 首字符
        if (!(*letterPoint > 'a' && *letterPoint < 'z') &&
            !(*letterPoint > 'A' && *letterPoint < 'Z')) {
            //汉字或其它字符
            char strChar= [HTFirstLetter pinyinFirstLetter:[str characterAtIndex:0]];
            letterPoint = &strChar;
        }
        //首字母转成大写
        firstLetter = [[NSString stringWithFormat:@"%c", *letterPoint] uppercaseString];
        
        //首字母所对应的 姓名列表
        NSMutableArray *mutArray = [mutDic objectForKey:firstLetter];
        
        if (mutArray == nil) {
            mutArray = [NSMutableArray array];
            [mutDic setObject:mutArray forKey:firstLetter];
        }
        
        [mutArray addObject:str];
    }
    
    //字典是无序的，数组是有序的，
    //将数组排序
    for (NSString *key in [mutDic allKeys]) {
        NSArray *nameArray = [[mutDic objectForKey:key] sortedArrayUsingSelector:@selector(compare:)];
        [mutDic setValue:nameArray forKey:key];
    }
    
    return mutDic;
}

- (NSArray *)map:(id (^)(id obj))block {
    __block NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [array addObject:block(obj)];
    }];
    return array;
}

- (NSArray *)mapWithIndex:(id (^)(id obj, NSUInteger idx))block {
    __block NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [array addObject:block(obj, idx)];
    }];
    return array;
}

- (NSArray *)each:(void (^)(id obj))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
    return self;
}

- (NSArray *)eachWithIndex:(void (^)(id obj, NSUInteger idx))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
    return self;
}

- (NSArray *)eachWithStop:(void (^)(id obj, BOOL *stop))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, stop);
    }];
    return self;
}

- (NSArray *)eachWithIndexAndStop:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx, stop);
    }];
    return self;
}

- (NSArray *)filter:(BOOL(^)(id obj))block {
    __block NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj)) {
            [array addObject:obj];
        }
    }];
    return [NSArray arrayWithArray:array];
}

- (id)find:(BOOL(^)(id obj))block {
    __block id ret = nil;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj)) {
            *stop = YES;
            ret = obj;
        }
    }];
    return ret;
}


@end

#pragma mark -

// No-ops for non-retaining objects.
static const void *	__TTRetainNoOp( CFAllocatorRef allocator, const void * value ) { return value; }
static void			__TTReleaseNoOp( CFAllocatorRef allocator, const void * value ) { }

#pragma mark -

@implementation NSMutableArray(BeeExtension)

@dynamic APPEND;

- (NSMutableArrayAppendBlock)APPEND
{
	NSMutableArrayAppendBlock block = ^ NSMutableArray * ( id obj )
	{
		[self addObject:obj];
		return self;
	};
	
	return [block copy];
}

+ (NSMutableArray *)nonRetainingArray	// copy from Three20
{
	CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
	callbacks.retain = __TTRetainNoOp;
	callbacks.release = __TTReleaseNoOp;
	return (NSMutableArray *)CFBridgingRelease(CFArrayCreateMutable( nil, 0, &callbacks ));
}

- (void)addUniqueObject:(id)object compare:(NSMutableArrayCompareBlock)compare
{
	BOOL found = NO;
	
	for ( id obj in self )
	{
		if ( compare )
		{
			NSComparisonResult result = compare( obj, object );
			if ( NSOrderedSame == result )
			{
				found = YES;
				break;
			}
		}
		else if ( [obj class] == [object class] && [obj respondsToSelector:@selector(compare:)] )
		{
			NSComparisonResult result = [obj compare:object];
			if ( NSOrderedSame == result )
			{
				found = YES;
				break;
			}
		}
	}
	
	if ( NO == found )
	{
		[self addObject:object];
	}
}

- (void)addUniqueObjects:(const id [])objects count:(NSUInteger)count compare:(NSMutableArrayCompareBlock)compare
{
	for ( int i = 0; i < count; ++i )
	{
		BOOL	found = NO;
		id		object = objects[i];

		for ( id obj in self )
		{
			if ( compare )
			{
				NSComparisonResult result = compare( obj, object );
				if ( NSOrderedSame == result )
				{
					found = YES;
					break;
				}
			}
			else if ( [obj class] == [object class] && [obj respondsToSelector:@selector(compare:)] )
			{
				NSComparisonResult result = [obj compare:object];
				if ( NSOrderedSame == result )
				{
					found = YES;
					break;
				}
			}
		}

		if ( NO == found )
		{
			[self addObject:object];
		}
	}
}

- (void)addUniqueObjectsFromArray:(NSArray *)array compare:(NSMutableArrayCompareBlock)compare
{
	for ( id object in array )
	{
		BOOL found = NO;

		for ( id obj in self )
		{
			if ( compare )
			{
				NSComparisonResult result = compare( obj, object );
				if ( NSOrderedSame == result )
				{
					found = YES;
					break;
				}
			}
			else if ( [obj class] == [object class] && [obj respondsToSelector:@selector(compare:)] )
			{
				NSComparisonResult result = [obj compare:object];
				if ( NSOrderedSame == result )
				{
					found = YES;
					break;
				}
			}
		}
		
		if ( NO == found )
		{
			[self addObject:object];
		}
	}
}

- (void)unique
{
	[self unique:^NSComparisonResult(id left, id right) {
		return [left compare:right];
	}];
}

- (void)unique:(NSMutableArrayCompareBlock)compare
{
	if ( self.count <= 1 )
	{
		return;
	}

	// Optimize later ...

	NSMutableArray * dupArray = [NSMutableArray nonRetainingArray];
	NSMutableArray * delArray = [NSMutableArray nonRetainingArray];

	[dupArray addObjectsFromArray:self];
	[dupArray sortUsingComparator:compare];
	
	for ( NSUInteger i = 0; i < dupArray.count; ++i )
	{
		id elem1 = [dupArray safeObjectAtIndex:i];
		id elem2 = [dupArray safeObjectAtIndex:(i + 1)];
		
		if ( elem1 && elem2 )
		{
			if ( NSOrderedSame == compare(elem1, elem2) )
			{
				[delArray addObject:elem1];
			}
		}
	}
	
	for ( id delElem in delArray )
	{
		[self removeObject:delElem];
	}
}

- (void)sort
{
	[self sort:^NSComparisonResult(id left, id right) {
		return [left compare:right];
	}];
}

- (void)sort:(NSMutableArrayCompareBlock)compare
{
	[self sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return compare( obj1, obj2 );
	}];
}

- (NSMutableArray *)pushHead:(NSObject *)obj
{
	if ( obj )
	{
		[self insertObject:obj atIndex:0];
	}
	
	return self;
}

- (NSMutableArray *)pushHeadN:(NSArray *)all
{
	if ( [all count] )
	{	
		for ( NSUInteger i = [all count]; i > 0; --i )
		{
			[self insertObject:[all objectAtIndex:i - 1] atIndex:0];
		}
	}
	
	return self;
}

- (NSMutableArray *)popTail
{
	if ( [self count] > 0 )
	{
		[self removeObjectAtIndex:[self count] - 1];
	}
	
	return self;
}

- (NSMutableArray *)popTailN:(NSUInteger)n
{
	if ( [self count] > 0 )
	{
		if ( n >= [self count] )
		{
			[self removeAllObjects];
		}
		else
		{
			NSRange range;
			range.location = n;
			range.length = [self count] - n;
			
			[self removeObjectsInRange:range];
		}
	}
	
	return self;
}

- (NSMutableArray *)pushTail:(NSObject *)obj
{
	if ( obj )
	{
		[self addObject:obj];		
	}
	
	return self;
}

- (NSMutableArray *)pushTailN:(NSArray *)all
{
	if ( [all count] )
	{
		[self addObjectsFromArray:all];		
	}
	
	return self;
}

- (NSMutableArray *)popHead
{
	if ( [self count] )
	{
		[self removeLastObject];
	}
	
	return self;
}

- (NSMutableArray *)popHeadN:(NSUInteger)n
{
	if ( [self count] > 0 )
	{
		if ( n >= [self count] )
		{
			[self removeAllObjects];
		}
		else
		{
			NSRange range;
			range.location = 0;
			range.length = n;
			
			[self removeObjectsInRange:range];
		}
	}
	
	return self;
}

- (NSMutableArray *)keepHead:(NSUInteger)n
{
	if ( [self count] > n )
	{
		NSRange range;
		range.location = n;
		range.length = [self count] - n;
		
		[self removeObjectsInRange:range];		
	}
	
	return self;
}

- (NSMutableArray *)keepTail:(NSUInteger)n
{
	if ( [self count] > n )
	{
		NSRange range;
		range.location = 0;
		range.length = [self count] - n;
		
		[self removeObjectsInRange:range];		
	}
	
	return self;
}

- (void)insertObjectNoRetain:(id)object atIndex:(NSUInteger)index
{
	[self insertObject:object atIndex:index];
}

- (void)addObjectNoRetain:(NSObject *)object
{
	[self addObject:object];
}

- (void)removeObjectNoRelease:(NSObject *)object
{
	[self removeObject:object];
}

- (void)removeAllObjectsNoRelease
{
	[self removeAllObjects];
}

- (void)removeObject:(NSObject *)obj usingComparator:(NSMutableArrayCompareBlock)cmptr
{
	if ( nil == cmptr || nil == obj )
		return;
	
	NSMutableArray * objectsWillRemove = [NSMutableArray nonRetainingArray];
	for ( id obj2 in self )
	{
		NSComparisonResult result = cmptr( obj, obj2 );
		if ( NSOrderedSame == result )
		{
			[objectsWillRemove addObject:obj2];
		}
	}
	
	[self removeObjectsInArray:objectsWillRemove];
}



@end

