//
//  MojoModel.h
//  MojoDB
//
//  Created by Craig Jolicoeur on 10/8/10.
//  Copyright 2010 Mojo Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModelLib.h"
@class MojoDatabase;

@interface MojoModel : JSONModel {
	NSUInteger primaryKey;
	BOOL savedInDatabase;
}

@property (nonatomic) NSUInteger primaryKey;
@property (nonatomic) BOOL savedInDatabase;

+(void)setDatabase:(MojoDatabase *)newDatabase;
+(MojoDatabase *)database;
-(void)save;
-(void)beforeSave;
-(void)afterSave;
-(void)delete;
-(void)beforeDelete;
+(NSArray *)findWithSql:(NSString *)sql withParameters:(NSArray *)parameters;
+(NSArray *)findWithSqlWithParameters:(NSString *)sql, ...;
+(NSArray *)findWithSql:(NSString *)sql;
+(NSArray *)findByColumn:(NSString *)column value:(id)value;
+(NSArray *)findByColumn:(NSString *)column unsignedIntegerValue:(NSUInteger)value;
+(NSArray *)findByColumn:(NSString *)column integerValue:(NSInteger)value;
+(NSArray *)findByColumn:(NSString *)column doubleValue:(double)value;
+(id)find:(NSUInteger)primaryKey;
+(NSArray *)findAll;
+(void)deleteAll;
	
@end
