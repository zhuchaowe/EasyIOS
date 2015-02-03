//
//  RACGestureRecognizerDelegate.m
//  GestureRecognizerRACExt
//
//  Created by kaiinui on 2014/09/07.
//  Copyright (c) 2014年 kaiinui. All rights reserved.
//

#import "RACGestureRecognizerActionHandler.h"

#import <ReactiveCocoa.h>

#import "UIGestureRecognizer+ReactiveCocoa.h"
#import "UIGestureRecognizer+ReactiveCocoaProtected.h"

@implementation RACGestureRecognizerActionHandler

- (void)rac_handleGesture:(UIGestureRecognizer *)recognizer {
    [[recognizer rac_subject] sendNext:recognizer];
}

@end
