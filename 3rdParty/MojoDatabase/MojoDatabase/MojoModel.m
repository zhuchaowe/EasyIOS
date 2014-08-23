//
//  MojoModel.m
//  MojoDB
//
//  Created by Craig Jolicoeur on 10/8/10.
//  Copyright 2010 Mojo Tech, LLC. All rights reserved.
//

#import "MojoModel.h"
#import "MojoDatabase.h"
#import <objc/runtime.h>
#define DBText  @"text"
#define DBInt   @"integer"
#define DBFloat @"real"
#define DBData  @"blob"
#define DBArray @"array"
#define DBObject @"object"
static MojoDatabase *database = nil;
static NSMutableDictionary *tableCache = nil;


@interface MojoModel(PrivateMethods)


-(void)insert;
-(void)updateAll;
@end

@interface MojoModel()
@property(nonatomic,retain)NSString *table;
@property(nonatomic,retain)NSString *field;
@property(nonatomic,retain)NSString *limit;
@property(nonatomic,retain)NSString *order;
@property(nonatomic,retain)NSString *where;
@property(nonatomic,retain)NSString *group;
@property(nonatomic,retain)NSMutableDictionary *map;
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
  [[self alloc] createTable];
  NSAssert1(database, @"Database not set. Set the database using [MojoModel setDatabase] before using Mojo Database methods.", @"");
}

#pragma mark - Class Methods - General

+(NSString *)tableName {
  return NSStringFromClass([self class]);
}

-(id)init
{
    self = [super init];
    if (self) {
        //do initial class setup
        [self resetAll];
    }
    return self;
}

-(void)resetAll{
    self.table = NSStringFromClass([self class]);
    self.field = @"*";
    self.where = @"primaryKey = ?";
    self.map = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:self.primaryKey] forKey:@"primaryKey"];
    self.order = @"";
    self.group = @"";
    self.limit = @"";
}

-(MojoModel*)table:(NSString *)table{
    self.table = table;
    return self;
}

-(MojoModel*)field:(id)field{
    if ([field isKindOfClass:[NSString class]]){
        self.field = field;
    }else if([field isKindOfClass:[NSArray class]]){
        self.field = [(NSArray*)field componentsJoinedByString:@","];
    }else{
        self.field = @"*";
    }
    return self;
}

-(MojoModel*)limit:(NSUInteger)start size:(NSUInteger)size{
    self.limit = [NSString stringWithFormat:@" LIMIT %lu,%lu",(unsigned long)start,(unsigned long)size];
    return self;
}

-(MojoModel*)order:(NSString *)order{
    self.order = [NSString stringWithFormat:@" ORDER BY %@",order];
    return self;
}

-(MojoModel*)group:(NSString *)group{
    self.group = [NSString stringWithFormat:@" GROUP BY %@",group];
    return self;
}

-(MojoModel*)where:(NSDictionary *)map{
    NSMutableString *where = [NSMutableString string];
    if(map != nil){
        [where appendString:@" WHERE 1"];
        [map enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* value, BOOL *stop) {
            if([key isEqualToString:@"_string"]){
                [where appendFormat:@" AND %@ ",value];
            }else{
                [where appendFormat:@" AND `%@` = ?",key];
            }
        }];
    }
    self.where = where;
    self.map = [NSMutableDictionary dictionaryWithDictionary:map];
    return self;
}

-(NSArray *)select{
    [[self class] assertDatabaseExists];
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ %@ %@ %@ %@",self.field,self.table,self.where,self.group,self.order,self.limit];
    NSMutableDictionary *dict = [self.map mutableCopy];
    [dict removeObjectForKey:@"_string"];
    NSArray *results = [database executeSql:sql withParameters:[dict allValues] withClassForRow:[self class]];
    [results setValue:[NSNumber numberWithBool:YES] forKey:@"savedInDatabase"];
    
    return results;
}

-(void)update:(NSDictionary *)data{
    [self beforeUpdate:data];
    if(savedInDatabase == YES){
        NSString *setValues = [[[data allKeys] componentsJoinedByString:@" = ?, "] stringByAppendingString:@" = ?"];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@", self.table, setValues,self.where];
        NSArray *parameters = [[data allValues] arrayByAddingObjectsFromArray:[self.map allValues]];
        [database executeSql:sql withParameters:parameters];
    }
    [self afterUpdate:data];
}

-(NSUInteger)getCount{
    [[self class] assertDatabaseExists];
    NSString *sql = [NSString stringWithFormat:@"SELECT count(*) AS c FROM %@ %@ %@ %@",self.table,self.where,self.group,self.order];
    NSMutableDictionary *dict = [self.map mutableCopy];
    [dict removeObjectForKey:@"_string"];
    NSArray *array = [database executeSql:sql withParameters:[dict allValues]];
    if(array.count >0 && [[array firstObject] objectForKey:@"c"]){
        NSNumber *count = [[array firstObject] objectForKey:@"c"];
        return count.integerValue;
    }else{
        return 0;
    }
}

/*
 * 判断一个表是否存在；
 */
- (BOOL)isTableExist{
    NSArray *tableArray = database.tableNames;
    for (NSString *tablename in tableArray) {
        if ([tablename isEqualToString:[self class].tableName]) {
            return YES;
        }
    }
    return NO;
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

-(void)createTable{
    if(!self.isTableExist){
        NSArray *propertyList = [self getPropertyList];
        
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (primaryKey integer primary key autoincrement, %@)", [[self class] tableName], [propertyList componentsJoinedByString:@","]];
        [database executeSql:sql];
    }
}

- (NSString *)dbTypeConvertFromObjc_property_t:(objc_property_t)property
{
    @synchronized(self){
        char * type = property_copyAttributeValue(property, "T");
        
        switch(type[0]) {
            case 'f' : //float
            case 'd' : //double
            {
                return DBFloat;
            }
                break;
                
            case 'c':   // char
            case 's' : //short
            case 'i':   // int
            case 'l':   // long
            {
                return DBInt;
            }
                break;
                
            case '*':   // char *
                break;
                
            case '@' : //ObjC object
                //Handle different clases in here
            {
                NSString *cls = [NSString stringWithUTF8String:type];
                cls = [cls stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                cls = [cls stringByReplacingOccurrencesOfString:@"@" withString:@""];
                cls = [cls stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                if ([NSClassFromString(cls) isSubclassOfClass:[NSString class]]) {
                    return DBText;
                }
                
                if ([NSClassFromString(cls) isSubclassOfClass:[NSNumber class]]) {
                    return DBText;
                }
                
                if ([NSClassFromString(cls) isSubclassOfClass:[NSDictionary class]] || [NSClassFromString(cls) isSubclassOfClass:[NSMutableDictionary class]]) {
                    return DBObject;
                }
                
                if ([NSClassFromString(cls) isSubclassOfClass:[NSArray class]] ||[NSClassFromString(cls) isSubclassOfClass:[NSMutableArray class]] ||
                    [cls hasPrefix:@"NSMutableArray"] ||
                    [cls hasPrefix:@"NSArray"]) {
                    return DBArray;
                }
                
                if ([NSClassFromString(cls) isSubclassOfClass:[NSDate class]]) {
                    return DBText;
                }
                
                if ([NSClassFromString(cls) isSubclassOfClass:[NSData class]]) {
                    return DBData;
                }
                
                if ([NSClassFromString(cls) isSubclassOfClass:[MojoModel class]]) {
                    return DBObject;
                }
            }
                break;
        }
        
        return DBText;
    }
}

-(NSArray *)getPropertyList{
    NSMutableArray *propertyNamesArray = [NSMutableArray array];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString * attributes = [self dbTypeConvertFromObjc_property_t:property];
        if(![attributes isEqualToString:DBObject] && ![attributes isEqualToString:DBArray]
           ){
            [propertyNamesArray addObject:[NSString stringWithFormat:@"%@ %@",[NSString stringWithUTF8String:name],attributes]];
        }
    }
    free(properties);
    return propertyNamesArray;
}

-(void)save {
  [[self class] assertDatabaseExists];
  [self beforeSave];

  if (!savedInDatabase) {
    [self insert];
  } else {
    [self updateAll];
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


-(void)updateAll {
  NSString *setValues = [[[self columnsWithoutPrimaryKey] componentsJoinedByString:@" = ?, "] stringByAppendingString:@" = ?"];
  NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE primaryKey = ?", [[self class] tableName], setValues];
  NSArray *parameters = [[self propertyValues] arrayByAddingObject:[NSNumber numberWithUnsignedInt:(unsigned int)primaryKey]];

  [database executeSql:sql withParameters:parameters];
  savedInDatabase = YES;
}

+(void)deleteWhere:(NSString *)where{
    [[self class] assertDatabaseExists];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", [[self class] tableName],where];
    [database executeSql:sql];
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
  [self beforeFindSql:&sql parameters:&parameters];
  NSArray *results = [database executeSql:sql withParameters:parameters withClassForRow:[self class]];
  [results setValue:[NSNumber numberWithBool:YES] forKey:@"savedInDatabase"];
  [self afterFind:&results];
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
-(void)beforeUpdate:(NSDictionary *)data{}
-(void)afterUpdate:(NSDictionary *)data{}
+(void)afterFind:(NSArray **)results{}
+(void)beforeFindSql:(NSString **)sql parameters:(NSArray **)parameters{}

#pragma mark -
#pragma mark Debugging Methods

-(void)testProperties {
  NSLog(@"column names: %@", [self columns]);
  NSLog(@"column names without primary key: %@", [self columnsWithoutPrimaryKey]);
  NSLog(@"propertyValues: %@", [self propertyValues]);
}

@end
