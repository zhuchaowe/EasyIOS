//
//  MojoDatabase.h
//  MojoDB
//
//  Created by Craig Jolicoeur on 10/8/10.
//  Copyright 2010 Mojo Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MojoDatabase : NSObject {
	NSString *pathToDatabase;
	BOOL logging;
	sqlite3 *database;
}

@property (nonatomic, retain) NSString *pathToDatabase;
@property (nonatomic) BOOL logging;

-(id) initWithPath:(NSString *)filePath;
-(id) initWithFileName:(NSString *)fileName;
-(NSArray *)executeSql:(NSString *)sql withParameters:(NSArray *)parameters;
-(NSArray *)executeSql:(NSString *)sql withParameters:(NSArray *)parameters withClassForRow:(Class)rowClass;
-(NSArray *)executeSql:(NSString *)sql;
-(NSArray *)executeSqlWithParameters:(NSString *)sql, ...;
-(NSArray *)tableNames;
-(void)beginTransaction;
-(void)commit;
-(void)rollback;
-(NSArray *)columnsForTableName:(NSString *)tableName;
-(NSUInteger)lastInsertRowId;

@end
