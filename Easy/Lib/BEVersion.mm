

#import "BEVersion.h"

NSString* const APP_VERSION = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
NSString* const APP_BULID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

#pragma mark -

@interface BEVersion()
{
	NSUInteger	_major;
	NSUInteger	_minor;
	NSUInteger	_tiny;
	NSString *	_pre;
}
@end

#pragma mark -

@implementation BEVersion

DEF_SINGLETON( BEVersion )

@synthesize major = _major;
@synthesize minor = _minor;
@synthesize tiny = _tiny;
@synthesize pre = _pre;




- (id)init
{
    if (self = [super init]){
       
		NSArray * array = [APP_VERSION componentsSeparatedByString:@" "];
		if ( array.count > 0 )
		{
			if ( array.count > 1 )
			{
				_pre = [array objectAtIndex:1] ;
			}
			else
			{
				_pre = @"";
			}
			
			NSArray * subvers = [[array objectAtIndex:0] componentsSeparatedByString:@"."];
			if ( subvers.count >= 1 )
			{
				_major = [[subvers objectAtIndex:0] intValue];
			}
			if ( subvers.count >= 2 )
			{
				_minor = [[subvers objectAtIndex:1] intValue];
			}
			if ( subvers.count >= 3 )
			{
				_tiny = [[subvers objectAtIndex:2] intValue];
			}
		}
    }
    return self;
}

-(BOOL)checkHasNewVersion:(NSString *)newVersion
{
    
    NSUInteger	new_major = 0;
	NSUInteger	new_minor = 0;
	NSUInteger	new_tiny = 0;
	NSString *	new_pre = @"";
    
    NSArray * array = [newVersion componentsSeparatedByString:@" "];
    if ( array.count > 0 )
    {
        if ( array.count > 1 )
        {
            new_pre = [array objectAtIndex:1];
        }
        else
        {
            new_pre = @"";
        }
        
        NSArray * subvers = [[array objectAtIndex:0] componentsSeparatedByString:@"."];
        if ( subvers.count >= 1 )
        {
            new_major = [[subvers objectAtIndex:0] intValue];
        }
        if ( subvers.count >= 2 )
        {
            new_minor = [[subvers objectAtIndex:1] intValue];
        }
        if ( subvers.count >= 3 )
        {
            new_tiny = [[subvers objectAtIndex:2] intValue];
        }
    }
    
    if (new_major > _major) {
        return YES;
    }
    
    if (new_minor > _minor) {
        return YES;
    }
    
    if (new_tiny > _tiny) {
        return YES;
    }
    
    if ( [new_pre compare:_pre] ) {
        return YES;
    }
    
    return NO;
}



@end
