

#import "EzSingleton.h"

extern NSString* const APP_VERSION;
extern NSString* const APP_BULID;

@interface BEVersion : NSObject

AS_SINGLETON( BEVersion )

@property (nonatomic, readonly) NSUInteger	major;
@property (nonatomic, readonly) NSUInteger	minor;
@property (nonatomic, readonly) NSUInteger	tiny;
@property (nonatomic, readonly) NSString *	pre;

-(BOOL)checkHasNewVersion:(NSString *)newVersion;
@end
