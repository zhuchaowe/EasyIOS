#import "EasyKit.h"
#import <objc/runtime.h>

@implementation EasyKit

+ (NSString *)homePath {
  return NSHomeDirectory();
}

+ (NSString *)desktopPath {
  return [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)documentPath {
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)appPath {
  return [[NSBundle mainBundle] bundlePath];
}

+ (NSString *)resourcePath {
  return [[NSBundle mainBundle] resourcePath];
}

+ (BOOL)swizzleMethod:(SEL)originalSelector with:(SEL)anotherSelector in:(Class)klass {
  return [self swizzleMethod:originalSelector in:klass with:anotherSelector in:klass];
}

+ (BOOL)swizzleMethod:(SEL)originalSelector in:(Class)klass with:(SEL)anotherSelector in:(Class)anotherKlass {
  Method originalMethod = class_getInstanceMethod(klass, originalSelector);
  Method anotherMethod  = class_getInstanceMethod(anotherKlass, anotherSelector);
  if(!originalMethod || !anotherMethod) {
    return NO;
  }
  IMP originalMethodImplementation = class_getMethodImplementation(klass, originalSelector);
  IMP anotherMethodImplementation  = class_getMethodImplementation(anotherKlass, anotherSelector);
  if(class_addMethod(klass, originalSelector, originalMethodImplementation, method_getTypeEncoding(originalMethod))) {
    originalMethod = class_getInstanceMethod(klass, originalSelector);
  }
  if(class_addMethod(anotherKlass, anotherSelector,  anotherMethodImplementation,  method_getTypeEncoding(anotherMethod))) {
    anotherMethod = class_getInstanceMethod(anotherKlass, anotherSelector);
  }
  method_exchangeImplementations(originalMethod, anotherMethod);
  return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)originalSelector with:(SEL)anotherSelector in:(Class)klass {
  return [self swizzleClassMethod:originalSelector in:klass with:anotherSelector in:klass];
}

+ (BOOL)swizzleClassMethod:(SEL)originalSelector in:(Class)klass with:(SEL)anotherSelector in:(Class)anotherKlass {
  Method originalMethod = class_getClassMethod(klass, originalSelector);
  Method anotherMethod  = class_getClassMethod(anotherKlass, anotherSelector);
  if(!originalMethod || !anotherMethod) {
    return NO;
  }
  Class metaClass = objc_getMetaClass(class_getName(klass));
  Class anotherMetaClass = objc_getMetaClass(class_getName(anotherKlass));
  IMP originalMethodImplementation = class_getMethodImplementation(metaClass, originalSelector);
  IMP anotherMethodImplementation  = class_getMethodImplementation(anotherMetaClass, anotherSelector);
  if(class_addMethod(metaClass, originalSelector, originalMethodImplementation, method_getTypeEncoding(originalMethod))) {
    originalMethod = class_getClassMethod(klass, originalSelector);
  }
  if(class_addMethod(anotherMetaClass, anotherSelector,  anotherMethodImplementation,  method_getTypeEncoding(anotherMethod))) {
    anotherMethod = class_getClassMethod(anotherKlass, anotherSelector);
  }
  method_exchangeImplementations(originalMethod, anotherMethod);
  return YES;
}

+ (void)waitUntil:(BOOL (^)(void))condition {
  [self waitUntil:condition timeOut:10.0 interval:0.1];
}

+ (void)waitUntil:(BOOL (^)(void))condition timeOut:(NSTimeInterval)timeOut {
  [self waitUntil:condition timeOut:timeOut interval:0.1];
}

+ (void)waitUntil:(BOOL (^)(void))condition timeOut:(NSTimeInterval)timeOut interval:(NSTimeInterval)interval {
  NSTimeInterval sleptSoFar=0;
  while(1) {
    if(condition() || (sleptSoFar >= timeOut)) {
      return;
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
    sleptSoFar += interval;
  }
}

@end

@implementation $
@end