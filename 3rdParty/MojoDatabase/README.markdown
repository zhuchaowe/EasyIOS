# Mojo Database

MojoDatabase is an ActiveRecord-like ORM for SQLite written in Objective-C for use in iOS applications.

The goal is to provide a nicer user interface for using SQLite with Objective-C applications via the ActiveRecord pattern.

## Installation

To install Mojo Database, simply drag the MojoDatabase directory into your XCode project and choose "copy files to destination" when prompted.

## Usage

Mojo Database has two (2) types of interaction with your Objective-C application.

* The "MojoModel" class will be used as a superclass of your model objects in your application.  Generally, these Mojo Models will map directly to a table in your SQLite database.
* The "AppDatabase" class is where you will define your database properties and schema and setup your migrations for updating the schema.

### Creating and Connecting to a SQLite DB

In your application delegate header file, you should should create an instance variable that will be used to referenc
e your database in the application.

    @class MojoDatabase;

    @interface MyAppDelegate : NSObject <UIApplicationDelegate> {
      MojoDatabase *myDatabase;
    }

    @property (nonatomic, retain) MojoDatabase *myDatabase;

    @end

In your application delegate implementation file, you should include the AppDatabase.h header file and create a connection to your DB during the app launch process.

    #import "AppDatabase.h"

    @implementation MyAppDelegate

    -(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      // Setup Connection to the database
      self.database = [[[AppDatabase alloc] initWithMigrations] autorelease];
    }

    -(void)dealloc {
      [database release], database=nil;
      [super dealloc];
    }

    @end

This will intialize (and create your databse if it didnt already exist) and also update the database to the current version by running any missing migrations.

If desired, you can customize the name of the SQLite database created by changing the `kDatabaseName` string at the top of the `AppDatabase.m` file.

### Creating Models

Each model you create should map directly to a SQLite table that was created via a migration entry.  So, if you had the following migration method in `AppDatabase.m`:

    -(void)createFriendTable {
      [self executeSql:@"CREATE TABLE Friend (primaryKey INTEGER primary key autoincrement, name TEXT, age INTEGER)"];
    }

you would also have an Objective-C class called `Friend` that inherited from `MojoModel`.  The following would be an example of your `Friend.h` header file:

    #import "MojoModel.h"

    @interface Friend : MojoMdel {
    }

    @property (nonatomic, retain) NSString *name;
    @property (nonatomic, retain) NSNumber *age;

    @end

with the following basic `Friend.m` implementation file:

    #import "Friend.h"

    @implementation Friend

    @synthesize name=_name;
    @synthesize age=_age;

    -(void)dealloc {
      [_name release], _name=nil;
      [_age release], _age=nil;
      [super dealloc];
    }

    @end

Creating a new friend object and saving it to your database would be as easy as:

    Friend *newFriend = [[Friend alloc] init];
    newFriend.name = @"Norman Rockwell";
    newFriend.age = [NSNumber numerWithInteger:55];
    [newFriend save];  // this will write out the new friend record to the databse

To later on retrieve that Friend object from the database:

    NSArray *records = [self findByColumn:@"name" value:@"Norman Rockwell"];
    if ( [records count] ) {
      Friend *normanRockwell = [records objectAtIndex:0];
    }

_Note that `findByColumn` always returns an `NSArray` object._

## Support

Please use the [GitHub Issues tracker](https://github.com/cpjolicoeur/mojo-database/issues) for any bug reports or feature requests.

## Contributions

If you wish to contribute to Mojo Database, please fork the project and send pull requests.

## Credits

Mojo Database is based largely on Dylan Bruzenak's code from the _iPhone Advanced Projects_ book, published by Apress, and was modified and extended by [Craig P Jolicoeur](http://github.com/cpjolicoeur).
