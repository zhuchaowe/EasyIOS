

#import "Bee_Singleton.h"

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BULID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#pragma mark -

@interface BEVersion : NSObject

AS_SINGLETON( BEVersion )

@property (nonatomic, readonly) NSUInteger	major;
@property (nonatomic, readonly) NSUInteger	minor;
@property (nonatomic, readonly) NSUInteger	tiny;
@property (nonatomic, readonly) NSString *	pre;

-(BOOL)checkHasNewVersion:(NSString *)newVersion;
@end
