//
//  GCDMacros.h
//  GCDObjC
//
//  Copyright (c) 2013 Mark Smith. All rights reserved.
//
//

/**
 *  Inserts code that executes a block only once, regardless of how many times the macro is invoked.
 *
 *  @param block The block to execute once.
 */
#ifndef GCDExecOnce
#define GCDExecOnce(block) \
{ \
  static dispatch_once_t predicate = 0; \
  dispatch_once(&predicate, block); \
}
#endif

/**
 *  Inserts code that declares, creates, and returns a single instance, regardless of how many times the macro is invoked.
 *
 *  @param block A block that creates and returns the instance value.
 */
#ifndef GCDSharedInstance
#define GCDSharedInstance(block) \
{ \
  static dispatch_once_t predicate = 0; \
  static id sharedInstance = nil; \
  dispatch_once(&predicate, ^{ sharedInstance = block(); }); \
  return sharedInstance; \
}
#endif
