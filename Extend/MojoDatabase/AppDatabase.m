//
//  AppDatabase.m
//  groove-iphone
//
//  Created by Craig Jolicoeur on 5/5/11.
//  Copyright 2011 Mojo Tech, LLC. All rights reserved.
//

#import "AppDatabase.h"

NSString *const kDatabaseName = @"MojoDatabase.sqlite3";

@interface AppDatabase(PrivateMethods)
-(void)runMigrations;
-(NSUInteger)databaseVersion;
-(void)setDatabaseVersion:(NSUInteger)newVersionNumber;

// Migration steps - v1
-(void)createApplicationPropertiesTable;

// Migration steps - v2 .. vN
@end



@implementation AppDatabase

-(id)initWithMigrations {
	self = [self initWithMigrations:NO];
	if (!self) { return nil; }
	
	return self;
}

-(id)initWithMigrations:(BOOL)loggingEnabled {
	self = [super initWithFileName:kDatabaseName];
	if (!self) { return nil; }

	[self setLogging:loggingEnabled];
	[self runMigrations];
	[MojoModel setDatabase:self];

	return self;
}

-(void)runMigrations {
	[self beginTransaction];
	
	// Turn on Foreign Key support
	[self executeSql:@"PRAGMA foreign_keys = ON"];
	
	NSArray *tableNames = [self tableNames];
	
	if (![tableNames containsObject:@"ApplicationProperties"]) {
		[self createApplicationPropertiesTable];
	}
    
	if ([self databaseVersion] < 2) {
		// Migrations for database version 1 will run here
  	[self setDatabaseVersion:2];
	}
	
	/* 
	 * To upgrade to version 3 of the DB do
	
		if ([self databaseVersion] < 3) {
			// ...
			[self setDatabaseVersion:3];
		}
	
	 *
	 */
	    
	[self commit];
}

#pragma mark - Migration Steps

- (void) createApplicationPropertiesTable {
	[self executeSql:@"create table ApplicationProperties (primaryKey integer primary key autoincrement, name text, value integer)"];
	[self executeSql:@"insert into ApplicationProperties (name, value) values('databaseVersion', 1)"];
}


#pragma mark - Convenience Methods

-(void)updateApplicationProperty:(NSString *)propertyName value:(id)value {
	[self executeSqlWithParameters:@"UPDATE ApplicationProperties SET value = ? WHERE name = ?", value, propertyName, nil];
}

-(id)getApplicationProperty:(NSString *)propertyName {
	NSArray *rows = [self executeSqlWithParameters:@"SELECT value FROM ApplicationProperties WHERE name = ?", propertyName, nil];
	
	if ([rows count] == 0) {
		return nil;
	}
	
	id object = [[rows lastObject] objectForKey:@"value"];
	if ([object isKindOfClass:[NSString class]]) {
		object = [NSNumber numberWithInteger:[(NSString *)object integerValue]];
	}
	return object;
}

-(void)setDatabaseVersion:(NSUInteger)newVersionNumber {
	return [self updateApplicationProperty:@"databaseVersion" value:[NSNumber numberWithUnsignedInteger:newVersionNumber]];
}

-(NSUInteger)databaseVersion {
	return [[self getApplicationProperty:@"databaseVersion"] unsignedIntegerValue];
}

@end
