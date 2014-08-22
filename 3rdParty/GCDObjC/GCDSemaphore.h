//
//  GCDSemaphore.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDSemaphore : NSObject

/**
 *  Returns the underlying dispatch semaphore object.
 *
 *  @return The dispatch semaphore object.
 */
@property (strong, readonly, nonatomic) dispatch_semaphore_t dispatchSemaphore;

/**
 *  Initializes a new semaphore with starting value 0.
 *
 *  @return The initialized instance.
 *  @see dispatch_semaphore_create()
 */
- (instancetype)init;

/**
 *  Initializes a new semaphore.
 *
 *  @param value The starting value for the semaphore.
 *  @return The initialized instance.
 *  @see dispatch_semaphore_create()
 */
- (instancetype)initWithValue:(long)value;

/**
 *  The GCDSemaphore designated initializer.
 *
 *  @param dispatchSemaphore A dispatch_semaphore_t object.
 *  @return The initialized instance.
 *  @see dispatch_semaphore_create()
 */
- (instancetype)initWithDispatchSemaphore:(dispatch_semaphore_t)dispatchSemaphore;

/**
 *  Signals (increments) the semaphore.
 *
 *  @return YES if a thread is awoken, NO otherwise.
 *  @see dispatch_semaphore_signal()
 */
- (BOOL)signal;

/**
 *  Waits forever for (decrements) the semaphore.
 *
 *  @see dispatch_semaphore_wait()
 */
- (void)wait;

/**
 *  Waits for (decrements) the semaphore.
 *
 *  @param seconds The time to wait in seconds.
 *  @return YES on success, NO if the timeout occurred.
 *  @see dispatch_semaphore_wait()
 */
- (BOOL)wait:(double)seconds;

@end