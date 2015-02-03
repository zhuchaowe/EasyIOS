//
//  UIGestureRecognizer+ReactiveCocoa.h
//  GestureRecognizerRACExt
//
//  Created by kaiinui on 2014/09/07.
//  Copyright (c) 2014年 kaiinui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;

@interface UIGestureRecognizer (ReactiveCocoa) // TODO: To make them private, separate them into a category.

# pragma mark - Instantiate

/**
 public: Instantiate the recognizer.
 */
+ (instancetype)rac_recognizer;

# pragma mark - RACSignal

/**
 public: RACSignal from the GestureRecognizer.
    [[recognizer rac_signal] subscribeNext:^(id x) {
        UITapGestureRecognizer *recognizer = x; // Cast the signal to the expected recognizer.
        // Do something
    }];
 */
- (RACSignal *)rac_signal;

@end
