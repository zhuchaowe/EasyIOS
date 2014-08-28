//
//  Reachability+RACExtensions.m
//  Pods
//
//  Created by Stefano Mondino on 28/03/14.
//
//

#import "Reachability+RACExtensions.h"

@implementation Reachability (RACExtensions)

- (RACSignal*) rac_notifyAllNetworkChanges {
    __weak Reachability* reach = self;    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        reach.reachableBlock = ^(Reachability* r){
            [subscriber sendNext:r];
        };
        reach.unreachableBlock = ^(Reachability* r){
            [subscriber sendNext:r];
        };
        [reach startNotifier];
        [subscriber sendNext:reach];
        return [RACDisposable disposableWithBlock:^{
            [reach stopNotifier];
        }];
    }];
}

@end
