//
//  UIGestureRecognizer+ReactiveCocoaProtected.h
//  GestureRecognizerRACExt
//
//  Created by kaiinui on 2014/09/07.
//  Copyright (c) 2014年 kaiinui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSubject;
@class RACGestureRecognizerActionHandler;

@interface UIGestureRecognizer (ReactiveCocoaProtected)

/**
 private: To retain UIGestureDelegate. The GestureRecognizer's delegate will be
 */
@property (nonatomic, strong) RACGestureRecognizerActionHandler *rac_gestureHandler;

/**
 protected: To retain subject while recognizing gestures.
 */
@property (nonatomic, strong) RACSubject *rac_subject;

@end
