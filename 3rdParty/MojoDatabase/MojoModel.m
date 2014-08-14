//
//  MojoModel.m
//  MojoDB
//
//  Created by Craig Jolicoeur on 10/8/10.
//  Copyright 2010 Mojo Tech, LLC. All rights reserved.
//

#import "MojoModel.h"
#import "MojoDatabase.h"

static MojoDatabase *database = nil;
static NSMutableDictionary *tableCache = nil;


@interface MojoModel(PrivateMethods)
-(void)insert;
-(void)update;
@end

@implementation MojoModel

@synthesize primaryKey;
@synthesize savedInDatabase;

#pragma mark - Class Methods - DB Handling

+(void)setDatabase:(MojoDatabase *)newDatabase {
  database = newDatabase;
}

+(MojoDatabase *)database {
  return database;
}

+(void)assertDatabaseExists {
  NSAssert1(database, @"Database not set. Set the database using [MojoModel setDatabase] before using Mojo Database methods.", @"");
}

#pragma mark - Class Methods - General

+(NSString *)tableName {
  return NSStringFromClass([self class]);
}


#pragma mark - DB Methods

-(NSArray *)columns {
  if (tableCache == nil) {
    tableCache = [NSMutableDictionary dictionary];
  }

  NSString *tableName = [[self class] tableName];
  NSArray *columns = [tableCache objectForKey:tableName];

  if (columns == nil) {
    columns = [database columnsForTableName:tableName];
    [tableCache setObject:columns forKey:tableName];
  }

  return columns;
}

-(NSArray *)columnsWithoutPrimaryKey {
  NSMutableArray *columns = [NSMutableArray arrayWithArray:[self columns]];
  [columns removeObjectAtIndex:0];
  return columns;
}

-(NSArray *)propertyValues {
  NSMutableArray *values = [NSMutableArray array];

  for (NSString *columnName in [self columnsWithoutPrimaryKey]) {
    id value = [self valueForKey:columnName];
    if (value != nil) {
      [values addObject:value];
    } else {
      [values addObject:[NSNull null]];
    }
  }

  return values;
}


#pragma mark - ActiveRecord-like Methods

-(void)save {
  [[self class] assertDatabaseExists];
  [self beforeSave];

  if (!savedInDatabase) {
    [self insert];
  } else {
    [self update];
  }

  [self afterSave];
}

-(void)insert {
  NSMutableArray *parameterList = [NSMutableArray array];
  NSArray *columnsWithoutPrimaryKey = [self columnsWithoutPrimaryKey];

  for (int i=0; i<[columnsWithoutPrimaryKey count]; i++) {
    [parameterList addObject:@"?"];
  }

  NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) values(%@)", [[self class] tableName], [columnsWithoutPrimaryKey componentsJoinedByString:@","], [parameterList componentsJoinedByString:@","]];
  [database executeSql:sql withParameters:[self propertyValues]];
  savedInDatabase = YES;
  primaryKey = [database lastInsertRowId];
}

-(void)update {
  NSString *setValues = [[[self columnsWithoutPrimaryKey] componentsJoinedByString:@" = ?, "] stringByAppendingString:@" = ?"];
  NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE primaryKey = ?", [[self class] tableName], setValues];
  NSArray *parameters = [[self propertyValues] arrayByAddingObject:[NSNumber numberWithUnsignedInt:(unsigned int)primaryKey]];

  [database executeSql:sql withParameters:parameters];
  savedInDatabase = YES;
}

-(void)delete {
  [[self class] assertDatabaseExists];
  if (!savedInDatabase) {
    return;
  }
  [self beforeDelete];

  NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE primaryKey = ?", [[self class] tableName]];
  [database executeSqlWithParameters:sql, [NSNumber numberWithUnsignedInt:(unsigned int)primaryKey], nil];
  savedInDatabase = NO;
  primaryKey = 0;
}

+(void)deleteAll {
  NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", [[self class] tableName]];
  [database executeSql:sql];
}

+(NSArray *)findWithSql:(NSString *)sql withParameters:(NSArray *)parameters {
  [self assertDatabaseExists];
  NSArray *results = [database executeSql:sql withParameters:parameters withClassForRow:[self class]];
  [results setValue:[NSNumber numberWithBool:YES] forKey:@"savedInDatabase"];
  return results;
}

+(NSArray *)findWithSqlWithParameters:(NSString *)sql, ... {
  va_list argumentList;
  va_start(argumentList, sql);

  NSMutableArray *arguments = [NSMutableArray array];
  id argument;
  while ((argument = va_arg(argumentList, id))) {
    [arguments addObject:argument];
  }

  va_end(argumentList);
  return [self findWithSql:sql withParameters:arguments];
}

+(NSArray *)findWithSql:(NSString *)sql {
  return [self findWithSqlWithParameters:sql, nil];
}

+(NSArray *)findByColumn:(NSString *)column value:(id)value {
  return [self findWithSqlWithParameters:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", [self tableName], column], value, nil];
}

+(NSArray *)findByColumn:(NSString *)column unsignedIntegerValue:(NSUInteger)value {
  return [self findByColumn:column value:[NSNumber numberWithUnsignedInteger:value]];
}

+(NSArray *)findByColumn:(NSString *)column integerValue:(NSInteger)value {
  return [self findByColumn:column value:[NSNumber numberWithInteger:value]];
}

+(NSArray *)findByColumn:(NSString *)column doubleValue:(double)value {
  return [self findByColumn:column value:[NSNumber numberWithDouble:value]];
}

+(id)find:(NSUInteger)primaryKey {
  NSArray *results = [self findByColumn:@"primaryKey" unsignedIntegerValue:primaryKey];

  if ([results count] < 1) {
    return nil;
  }
  return [results objectAtIndex:0];
}

+(NSArray *)findAll {
  return [self findWithSql:[NSString stringWithFormat:@"SELECT * FROM %@", [self tableName]]];
}


/*
 * AR-like Callbacks
 */

-(void)beforeSave {}
-(void)afterSave {}
-(void)beforeDelete {}


#pragma mark -
#pragma mark Debugging Methods

-(void)testProperties {
  NSLog(@"column names: %@", [self columns]);
  NSLog(@"column names without primary key: %@", [self columnsWithoutPrimaryKey]);
  NSLog(@"propertyValues: %@", [self propertyValues]);
}

@end
