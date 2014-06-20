//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Bee_Singleton.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	__PRELOAD_SINGLETON__
#define __PRELOAD_SINGLETON__	(__OFF__)

#pragma mark -

@implementation BeeSingleton

+ (BOOL)autoLoad
{
#if defined(__PRELOAD_SINGLETON__) && __PRELOAD_SINGLETON__
	
	INFO( @"Loading singletons ..." );
	
	[[BeeLogger sharedInstance] indent];
//	[[BeeLogger sharedInstance] disable];

	NSMutableArray * availableClasses = [NSMutableArray arrayWithArray:[BeeRuntime allSubClassesOf:[NSObject class]]];
	[availableClasses sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [[obj1 description] compare:[obj2 description]];
	}];
	
	for ( Class classType in availableClasses )
	{
		if ( [classType instancesRespondToSelector:@selector(sharedInstance)] )
		{
			[classType sharedInstance];
			
//			[[BeeLogger sharedInstance] enable];
			INFO( @"%@ loaded", [classType description] );
//			[[BeeLogger sharedInstance] disable];
		}
	}

	[[BeeLogger sharedInstance] unindent];
//	[[BeeLogger sharedInstance] enable];

#endif	// #if defined(__PRELOAD_SINGLETON__) && __PRELOAD_SINGLETON__

	return YES;
}

@end
