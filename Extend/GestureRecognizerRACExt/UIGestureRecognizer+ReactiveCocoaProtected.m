//
//  UIGestureRecognizer+ReactiveCocoaProtected.m
//  GestureRecognizerRACExt
//
//  Created by kaiinui on 2014/09/07.
//  Copyright (c) 2014年 kaiinui. All rights reserved.
//

#import "UIGestureRecognizer+ReactiveCocoaProtected.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (ReactiveCocoaProtected)

@dynamic rac_gestureHandler, rac_subject;

# pragma mark - AssociatedObject

- (void)setRac_gestureHandler:(RACGestureRecognizerActionHandler *)rac_gestureDelegate {
    objc_setAssociatedObject(self, @selector(rac_gestureHandler), rac_gestureDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RACGestureRecognizerActionHandler *)rac_gestureHandler {
    return objc_getAssociatedObject(self, @selector(rac_gestureHandler));
}

- (void)setRac_subject:(RACSubject *)rac_subject {
    objc_setAssociatedObject(self, @selector(rac_subject), rac_subject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RACSubject *)rac_subject {
    return objc_getAssociatedObject(self, @selector(rac_subject));
}

@end
