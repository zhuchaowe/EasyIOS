//
//  UIGestureRecognizer+ReactiveCocoa.m
//  GestureRecognizerRACExt
//
//  Created by kaiinui on 2014/09/07.
//  Copyright (c) 2014年 kaiinui. All rights reserved.
//

#import "UIGestureRecognizer+ReactiveCocoa.h"

#import <objc/runtime.h>
#import <ReactiveCocoa.h>
#import "RACGestureRecognizerActionHandler.h"

#import "UIGestureRecognizer+ReactiveCocoaProtected.h"

@implementation UIGestureRecognizer (ReactiveCocoa)

# pragma mark - Public

+ (instancetype)rac_recognizer {
    UIGestureRecognizer *recognizer = [[self alloc] init];
    [recognizer rac_initializeRAC];
    [recognizer addTarget:recognizer.rac_gestureHandler action:@selector(rac_handleGesture:)];
    return recognizer;
}

- (RACSignal *)rac_signal {
    return self.rac_subject;
}

# pragma mark - Helpers (Initialization)

- (void)rac_initializeRAC {
    self.rac_gestureHandler = [[RACGestureRecognizerActionHandler alloc] init];
    self.rac_subject = [RACSubject subject];
}

@end
