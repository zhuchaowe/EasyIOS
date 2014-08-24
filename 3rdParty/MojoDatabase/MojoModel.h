//
//  MojoModel.h
//  MojoDB
//
//  Created by Craig Jolicoeur on 10/8/10.
//  Copyright 2010 Mojo Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MojoDatabase;

@interface MojoModel : NSObject {
	NSUInteger primaryKey;
	BOOL savedInDatabase;
}

@property (nonatomic) NSUInteger primaryKey;
@property (nonatomic) BOOL savedInDatabase;



+(void)setDatabase:(MojoDatabase *)newDatabase;
+(MojoDatabase *)database;
-(void)resetAll;
-(MojoModel*)table:(NSString *)table;
-(MojoModel*)field:(id)field;
-(MojoModel*)limit:(NSUInteger)start size:(NSUInteger)size;
-(MojoModel*)order:(NSString *)order;
-(MojoModel*)group:(NSString *)group;
-(MojoModel*)where:(NSDictionary *)map;
-(NSArray *)select;
-(NSUInteger)getCount;

-(void)update:(NSDictionary *)data;
-(void)beforeUpdate:(NSDictionary *)data;
-(void)afterUpdate:(NSDictionary *)data;

-(void)save;
-(void)beforeSave;
-(void)afterSave;

-(void)deleteSelf;
-(void)beforeDeleteSelf;
-(void)afterDeleteSelf;

-(void)delete;
-(void)beforeDelete;
-(void)afterDelete;


+(void)afterFind:(NSArray **)results;
+(void)beforeFindSql:(NSString **)sql parameters:(NSArray **)parameters;
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
-(BOOL)isTableExist;
-(void)createTable;
@end
