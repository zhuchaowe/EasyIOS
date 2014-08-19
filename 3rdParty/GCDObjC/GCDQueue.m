//
//  GCDQueue.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDGroup.h"
#import "GCDQueue.h"

static GCDQueue *mainQueue;
static GCDQueue *globalQueue;
static GCDQueue *highPriorityGlobalQueue;
static GCDQueue *lowPriorityGlobalQueue;
static GCDQueue *backgroundPriorityGlobalQueue;

@interface GCDQueue ()
@property (strong, readwrite, nonatomic) dispatch_queue_t dispatchQueue;
@end

@implementation GCDQueue

#pragma mark Global queue accessors.

+ (GCDQueue *)mainQueue {
  return mainQueue;
}

+ (GCDQueue *)globalQueue {
  return globalQueue;
}

+ (GCDQueue *)highPriorityGlobalQueue {
  return highPriorityGlobalQueue;
}

+ (GCDQueue *)lowPriorityGlobalQueue {
  return lowPriorityGlobalQueue;
}

+ (GCDQueue *)backgroundPriorityGlobalQueue {
  return backgroundPriorityGlobalQueue;
}

#pragma mark Lifecycle.

+ (void)initialize {
  if (self == [GCDQueue class]) {
    mainQueue = [[GCDQueue alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    globalQueue = [[GCDQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    highPriorityGlobalQueue = [[GCDQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
    lowPriorityGlobalQueue = [[GCDQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)];
    backgroundPriorityGlobalQueue = [[GCDQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
  }
}

- (instancetype)init {
  return [self initSerial];
}

- (instancetype)initSerial {
  return [self initWithDispatchQueue:dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)];
}

- (instancetype)initConcurrent {
  return [self initWithDispatchQueue:dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)];
}

- (instancetype)initWithDispatchQueue:(dispatch_queue_t)dispatchQueue {
  if ((self = [super init]) != nil) {
    self.dispatchQueue = dispatchQueue;
  }
  
  return self;
}

#pragma mark Public block methods.

- (void)queueBlock:(dispatch_block_t)block {
  dispatch_async(self.dispatchQueue, block);
}

- (void)queueBlock:(dispatch_block_t)block afterDelay:(double)seconds {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC)), self.dispatchQueue, block);
}

- (void)queueAndAwaitBlock:(dispatch_block_t)block {
  dispatch_sync(self.dispatchQueue, block);
}

- (void)queueAndAwaitBlock:(void (^)(size_t))block iterationCount:(size_t)count {
  dispatch_apply(count, self.dispatchQueue, block);
}

- (void)queueBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group {
  dispatch_group_async(group.dispatchGroup, self.dispatchQueue, block);
}

- (void)queueNotifyBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group {
  dispatch_group_notify(group.dispatchGroup, self.dispatchQueue, block);
}

- (void)queueBarrierBlock:(dispatch_block_t)block {
  dispatch_barrier_async(self.dispatchQueue, block);
}

- (void)queueAndAwaitBarrierBlock:(dispatch_block_t)block {
  dispatch_barrier_sync(self.dispatchQueue, block);
}

#pragma mark Misc public methods.

- (void)suspend {
  dispatch_suspend(self.dispatchQueue);
}

- (void)resume {
  dispatch_resume(self.dispatchQueue);
}

@end
