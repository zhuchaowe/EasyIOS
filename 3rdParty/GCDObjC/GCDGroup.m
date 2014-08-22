//
//  GCDGroup.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDGroup.h"

@interface GCDGroup ()
@property (strong, readwrite, nonatomic) dispatch_group_t dispatchGroup;
@end

@implementation GCDGroup

#pragma mark Lifecycle.

- (instancetype)init {
  return [self initWithDispatchGroup:dispatch_group_create()];
}

- (instancetype)initWithDispatchGroup:(dispatch_group_t)dispatchGroup {
  if ((self = [super init]) != nil) {
    self.dispatchGroup = dispatchGroup;
  }
  
  return self;
}

#pragma mark Public methods.

- (void)enter {
  dispatch_group_enter(self.dispatchGroup);
}

- (void)leave {
  dispatch_group_leave(self.dispatchGroup);
}

- (void)wait {
  dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(double)seconds {
  return dispatch_group_wait(self.dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC))) == 0;
}

@end
