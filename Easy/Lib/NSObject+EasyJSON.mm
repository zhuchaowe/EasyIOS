//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//
 
#import "NSObject+EasyJSON.h"
#import "Easy_Runtime.h"
#import "NSObject+EasyTypeConversion.h"
#import "NSDictionary+EasyExtend.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(EasyJSON)

+ (id)objectsFromArray:(id)arr
{
	if ( nil == arr )
		return nil;
	
	if ( NO == [arr isKindOfClass:[NSArray class]] )
		return nil;

	NSMutableArray * results = [NSMutableArray array];

	for ( NSObject * obj in (NSArray *)arr )
	{
		if ( [obj isKindOfClass:[NSDictionary class]] )
		{
			NSDictionary *dict = [self objectFromDictionary:obj];
			if ( dict )
			{
				[results addObject:dict];
			}
		}
		else
		{
			[results addObject:obj];
		}
	}

	return results;
}

+ (id)objectsFromAny:(id)any
{
	if ( nil == any )
	{
		return nil;
	}
	
	if ( [any isKindOfClass:[NSArray class]] )
	{
		return [self objectsFromArray:any];
	}
	else if ( [any isKindOfClass:[NSDictionary class]] )
	{
		id obj = [self objectFromDictionary:any];
		if ( nil == obj )
			return nil;

		if ( [obj isKindOfClass:[NSArray class]] )
		{
			return obj;
		}
		else
		{
			return [NSArray arrayWithObject:obj];
		}
	}
	else if ( [any isKindOfClass:[NSString class]] )
	{
		id obj = [self objectFromString:any];
		if ( nil == obj )
			return nil;
		
		if ( [obj isKindOfClass:[NSArray class]] )
		{
			return obj;
		}
		else
		{
			return [NSArray arrayWithObject:obj];
		}
	}
	else if ( [any isKindOfClass:[NSData class]] )
	{
		id obj = [self objectFromData:any];
		if ( nil == obj )
			return nil;
		
		if ( [obj isKindOfClass:[NSArray class]] )
		{
			return obj;
		}
		else
		{
			return [NSArray arrayWithObject:obj];
		}
	}
	else
	{
		return [NSArray arrayWithObject:any];
	}
}

+ (id)objectFromDictionary:(id)dict
{
	if ( nil == dict )
	{
		return nil;
	}
		
	if ( NO == [dict isKindOfClass:[NSDictionary class]] )
	{
		return nil;
	}
	return (NSDictionary *)dict;
}

+ (id)objectFromString:(id)str
{
	if ( nil == str )
	{
		return nil;
	}
	
	if ( NO == [str isKindOfClass:[NSString class]] )
	{
		return nil;
	}
	NSError * error = nil;
    
	NSObject * obj = [NSJSONSerialization JSONObjectWithData:(NSData *)str options:0 error:&error];

	if ( nil == obj )
	{
		NSLog( @"%@", error );
		return nil;
	}
	
	if ( [obj isKindOfClass:[NSDictionary class]] )
	{
		return [self objectFromDictionary:obj];
	}
	else if ( [obj isKindOfClass:[NSArray class]] )
	{
		NSMutableArray * array = [NSMutableArray array];
		
		for ( NSObject * elem in (NSArray *)obj )
		{
			if ( [elem isKindOfClass:[NSDictionary class]] )
			{
				NSDictionary * result = [self objectFromDictionary:elem];
				if ( result )
				{
					[array addObject:elem];
				}
			}
		}
		
		return array;
	}
	else if ( [BeeTypeEncoding isAtomClass:[obj class]] )
	{
		return obj;
	}
	
	return nil;
}

+ (id)objectFromData:(id)data
{
	if ( nil == data )
	{
		return nil;
	}
	
	if ( NO == [data isKindOfClass:[NSData class]] )
	{
		return nil;
	}
    NSError * error = nil;
    
	NSObject * obj = [NSJSONSerialization JSONObjectWithData:(NSData *)data options:0 error:&error];
    
    if(obj == nil){
        NSLog(@"%@",error);
    }
	if ( obj )
	{
		if ( [obj isKindOfClass:[NSDictionary class]] )
		{
            return [self objectFromDictionary:obj];
		}
		else if ( [obj isKindOfClass:[NSArray class]] )
		{
            return [self objectsFromArray:obj];
		}
	}

	return nil;
}

+ (id)objectFromAny:(id)any
{
	if ( [any isKindOfClass:[NSArray class]] )
	{
		return [self objectsFromArray:any];
	}
	else if ( [any isKindOfClass:[NSDictionary class]] )
	{
		return [self objectFromDictionary:any];
	}
	else if ( [any isKindOfClass:[NSString class]] )
	{
		return [self objectFromString:any];
	}
	else if ( [any isKindOfClass:[NSData class]] )
	{
		return [self objectFromData:any];
	}
	
	return any;
}

- (id)objectToDictionary
{
	return [self objectToDictionaryUntilRootClass:nil];
}

- (id)objectToDictionaryUntilRootClass:(Class)rootClass
{
	NSMutableDictionary * result = [NSMutableDictionary dictionary];
	
	if ( [self isKindOfClass:[NSDictionary class]] )
	{
		NSDictionary * dict = (NSDictionary *)self;

		for ( NSString * key in dict.allKeys )
		{
			NSObject * obj = [dict objectForKey:key];
			if ( obj )
			{
				NSUInteger propertyType = [BeeTypeEncoding typeOfObject:obj];
				if ( BeeTypeEncoding.NSNUMBER == propertyType )
				{
					[result setObject:obj forKey:key];
				}
				else if ( BeeTypeEncoding.NSSTRING == propertyType )
				{
					[result setObject:obj forKey:key];
				}
				else if ( BeeTypeEncoding.NSARRAY == propertyType )
				{
					NSMutableArray * array = [NSMutableArray array];
					
					for ( NSObject * elem in (NSArray *)obj )
					{
						NSDictionary * dict = [elem objectToDictionaryUntilRootClass:rootClass];
						if ( dict )
						{
							[array addObject:dict];
						}
						else
						{
							if ( [BeeTypeEncoding isAtomClass:[elem class]] )
							{
								[array addObject:elem];
							}
						}
					}
					
					[result setObject:array forKey:key];
				}
				else if ( BeeTypeEncoding.NSDICTIONARY == propertyType )
				{
					NSMutableDictionary * dict = [NSMutableDictionary dictionary];
					
					for ( NSString * key in ((NSDictionary *)obj).allKeys )
					{
						NSObject * val = [(NSDictionary *)obj objectForKey:key];
						if ( val )
						{
							NSDictionary * subresult = [val objectToDictionaryUntilRootClass:rootClass];
							if ( subresult )
							{
								[dict setObject:subresult forKey:key];
							}
							else
							{
								if ( [BeeTypeEncoding isAtomClass:[val class]] )
								{
									[dict setObject:val forKey:key];
								}
							}
						}
					}
					
					[result setObject:dict forKey:key];
				}
				else if ( BeeTypeEncoding.NSDATE == propertyType )
				{
					[result setObject:[obj description] forKey:key];
				}
				else
				{
					obj = [obj objectToDictionaryUntilRootClass:rootClass];
					if ( obj )
					{
						[result setObject:obj forKey:key];
					}
					else
					{
						[result setObject:[NSDictionary dictionary] forKey:key];
					}
				}
			}
//			else
//			{
//				[result setObject:[NSNull null] forKey:key];
//			}
		}
	}
	else
	{
		for ( Class clazzType = [self class];; )
		{
			if ( rootClass )
			{
				if ( clazzType == rootClass )
					break;
			}
			else
			{
				if ( [BeeTypeEncoding isAtomClass:clazzType] )
					break;
			}

			unsigned int		propertyCount = 0;
			objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
			
			for ( NSUInteger i = 0; i < propertyCount; i++ )
			{
				const char *	name = property_getName(properties[i]);
				const char *	attr = property_getAttributes(properties[i]);
				
				NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
				NSUInteger		propertyType = [BeeTypeEncoding typeOf:attr];
				
				NSObject * obj = [self valueForKey:propertyName];
				if ( obj )
				{
					if ( BeeTypeEncoding.NSNUMBER == propertyType )
					{
						[result setObject:obj forKey:propertyName];
					}
					else if ( BeeTypeEncoding.NSSTRING == propertyType )
					{
						[result setObject:obj forKey:propertyName];
					}
					else if ( BeeTypeEncoding.NSARRAY == propertyType )
					{
						NSMutableArray * array = [NSMutableArray array];
						
						for ( NSObject * elem in (NSArray *)obj )
						{
							NSUInteger elemType = [BeeTypeEncoding typeOfObject:elem];
							
							if ( BeeTypeEncoding.NSNUMBER == elemType )
							{
								[array addObject:elem];
							}
							else if ( BeeTypeEncoding.NSSTRING == elemType )
							{
								[array addObject:elem];
							}
							else
							{
								NSDictionary * dict = [elem objectToDictionaryUntilRootClass:rootClass];
								if ( dict )
								{
									[array addObject:dict];
								}
								else
								{
									if ( [BeeTypeEncoding isAtomClass:[elem class]] )
									{
										[array addObject:elem];
									}
								}
							}
						}
						
						[result setObject:array forKey:propertyName];
					}
					else if ( BeeTypeEncoding.NSDICTIONARY == propertyType )
					{
						NSMutableDictionary * dict = [NSMutableDictionary dictionary];
						
						for ( NSString * key in ((NSDictionary *)obj).allKeys )
						{
							NSObject * val = [(NSDictionary *)obj objectForKey:key];
							if ( val )
							{
								NSDictionary * subresult = [val objectToDictionaryUntilRootClass:rootClass];
								if ( subresult )
								{
									[dict setObject:subresult forKey:key];
								}
								else
								{
									if ( [BeeTypeEncoding isAtomClass:[val class]] )
									{
										[dict setObject:val forKey:key];
									}
								}
							}
						}
						
						[result setObject:dict forKey:propertyName];
					}
					else if ( BeeTypeEncoding.NSDATE == propertyType )
					{
						[result setObject:[obj description] forKey:propertyName];
					}
					else
					{
						obj = [obj objectToDictionaryUntilRootClass:rootClass];
						if ( obj )
						{
							[result setObject:obj forKey:propertyName];
						}
						else
						{
							[result setObject:[NSDictionary dictionary] forKey:propertyName];
						}
					}
				}
//				else
//				{
//					[result setObject:[NSNull null] forKey:propertyName];
//				}
			}
			
			free( properties );

			clazzType = class_getSuperclass( clazzType );
			if ( nil == clazzType )
				break;
		}
	}
	
	return result.count ? result : nil;
}

- (id)objectZerolize
{
	return [self objectZerolizeUntilRootClass:nil];
}

- (id)objectZerolizeUntilRootClass:(Class)rootClass
{
	for ( Class clazzType = [self class];; )
	{
		if ( rootClass )
		{
			if ( clazzType == rootClass )
				break;
		}
		else
		{
			if ( [BeeTypeEncoding isAtomClass:clazzType] )
				break;
		}

		unsigned int		propertyCount = 0;
		objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
		
		for ( NSUInteger i = 0; i < propertyCount; i++ )
		{
			const char *	name = property_getName(properties[i]);
			const char *	attr = property_getAttributes(properties[i]);
			
			NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
			NSUInteger		propertyType = [BeeTypeEncoding typeOfAttribute:attr];
			
			if ( BeeTypeEncoding.NSNUMBER == propertyType )
			{
				[self setValue:[NSNumber numberWithInt:0] forKey:propertyName];
			}
			else if ( BeeTypeEncoding.NSSTRING == propertyType )
			{
				[self setValue:@"" forKey:propertyName];
			}
			else if ( BeeTypeEncoding.NSARRAY == propertyType )
			{
				[self setValue:[NSMutableArray array] forKey:propertyName];
			}
			else if ( BeeTypeEncoding.NSDICTIONARY == propertyType )
			{
				[self setValue:[NSMutableDictionary dictionary] forKey:propertyName];
			}
			else if ( BeeTypeEncoding.NSDATE == propertyType )
			{
				[self setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:propertyName];
			}
			else if ( BeeTypeEncoding.OBJECT == propertyType )
			{
				Class clazz = [BeeTypeEncoding classOfAttribute:attr];
				if ( clazz )
				{
					NSObject * newObj = [[clazz alloc] init];
					[self setValue:newObj forKey:propertyName];
				}
				else
				{
					[self setValue:nil forKey:propertyName];
				}
			}
			else
			{
				[self setValue:nil forKey:propertyName];
			}
		}
		
		free( properties );
		
		clazzType = class_getSuperclass( clazzType );
		if ( nil == clazzType )
			break;
	}
	
	return self;
}

- (id)objectToString
{
	return [self objectToStringUntilRootClass:nil];
}

- (id)objectToStringUntilRootClass:(Class)rootClass
{
	NSString *	json = nil;
	NSUInteger	propertyType = [BeeTypeEncoding typeOfObject:self];
	
	if ( BeeTypeEncoding.NSNUMBER == propertyType )
	{
		json = [self asNSString];
	}
	else if ( BeeTypeEncoding.NSSTRING == propertyType )
	{
		json = [self asNSString];
	}
	else if ( BeeTypeEncoding.NSARRAY == propertyType )
	{
		NSMutableArray * array = [NSMutableArray array];

		for ( NSObject * elem in (NSArray *)self )
		{
			NSDictionary * dict = [elem objectToDictionaryUntilRootClass:rootClass];
			if ( dict )
			{
				[array addObject:dict];
			}
			else
			{
				if ( [BeeTypeEncoding isAtomClass:[elem class]] )
				{
					[array addObject:elem];
				}
			}
		}
		json = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:array
                                                                              options:NSJSONWritingPrettyPrinted
                                                                                error:nil]
                                     encoding:NSUTF8StringEncoding];
	}
	else if ( BeeTypeEncoding.NSDICTIONARY == propertyType )
	{
		NSDictionary * dict = [self objectToDictionaryUntilRootClass:rootClass];
		if ( dict )
		{
			json = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict
                                                                                  options:NSJSONWritingPrettyPrinted
                                                                                    error:nil]
                                         encoding:NSUTF8StringEncoding];
		}
	}
	else if ( BeeTypeEncoding.NSDATE == propertyType )
	{
		json = [self description];
	}
	else
	{
		NSDictionary * dict = [self objectToDictionaryUntilRootClass:rootClass];
		if ( nil == dict )
		{
			dict = [NSDictionary dictionary];
		}
		
		json = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict
                                                                              options:NSJSONWritingPrettyPrinted
                                                                                error:nil]
                                     encoding:NSUTF8StringEncoding];
	}

	if ( nil == json || 0 == json.length )
		return nil;
	
	return [NSMutableString stringWithString:json];
}

- (id)objectToData
{
	return [self objectToDataUntilRootClass:nil];
}

- (id)objectToDataUntilRootClass:(Class)rootClass
{
	NSString * string = [self objectToStringUntilRootClass:rootClass];
	if ( nil == string )
		return nil;

	return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)serializeObject
{
	NSUInteger type = [BeeTypeEncoding typeOfObject:self];
	
	if ( BeeTypeEncoding.NSNUMBER == type )
	{
		return self;
	}
	else if ( BeeTypeEncoding.NSSTRING == type )
	{
		return self;
	}
	else if ( BeeTypeEncoding.NSDATE == type )
	{
		return self;
	}
	else if ( BeeTypeEncoding.NSARRAY == type )
	{
		NSArray *			array = (NSArray *)self;
		NSMutableArray *	result = [NSMutableArray array];
		
		for ( NSObject * elem in array )
		{
			NSObject * val = [elem serializeObject];
			if ( val )
			{
				[result addObject:val];
			}
		}
		
		return result;
	}
	else if ( BeeTypeEncoding.NSDICTIONARY == type )
	{
		NSDictionary *			dict = (NSDictionary *)self;
		NSMutableDictionary *	result = [NSMutableDictionary dictionary];
		
		for ( NSString * key in dict.allKeys )
		{
			NSObject * val = [dict objectForKey:key];
			NSObject * val2 = [val serializeObject];

			if ( val2 )
			{
				[result setObject:val2 forKey:key];
			}
		}

		return result;
	}
	else if ( BeeTypeEncoding.OBJECT == type )
	{
		return [self objectToDictionary];
	}

	return nil;
}

+ (id)unserializeObject:(id)obj
{
	NSUInteger type = [BeeTypeEncoding typeOfObject:obj];
	
	if ( BeeTypeEncoding.NSNUMBER == type )
	{
		return self;
	}
	else if ( BeeTypeEncoding.NSSTRING == type )
	{
		return [self objectFromString:obj];
	}
	else if ( BeeTypeEncoding.NSDATE == type )
	{
		return self;
	}
	else if ( BeeTypeEncoding.NSARRAY == type )
	{
		return [self objectsFromArray:obj];
	}
	else if ( BeeTypeEncoding.NSDICTIONARY == type )
	{
		return [self objectFromDictionary:obj];
	}
	else if ( BeeTypeEncoding.OBJECT == type )
	{
		return self;
	}

	return nil;
}

-(BOOL)isNotEmpty{
    return !(self == nil
             || [self isKindOfClass:[NSNull class]]
             || ([self respondsToSelector:@selector(length)]
                 && [(NSData *)self length] == 0)
             || ([self respondsToSelector:@selector(count)]
                 && [(NSArray *)self count] == 0));
    
}

@end

