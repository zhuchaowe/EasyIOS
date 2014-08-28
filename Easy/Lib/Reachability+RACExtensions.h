//
//  Reachability+RACExtensions.h
//  Pods
//
//  Created by Stefano Mondino on 28/03/14.
//
//

#import "Reachability.h"
#import <ReactiveCocoa.h>

@interface Reachability (RACExtensions)

- (RACSignal*) rac_notifyAllNetworkChanges;
@end
