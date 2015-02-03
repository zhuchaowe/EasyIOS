//
//  UIView+EzGesture.m
//  mcapp
//
//  Created by zhuchao on 15/2/3.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "UIView+EzGesture.h"

@implementation UIView (EzGesture)

-(void)whenTapped:(void (^)(void))block{
    UITapGestureRecognizer *recognizer = [UITapGestureRecognizer rac_recognizer];
    [self addGestureRecognizer:recognizer];
    [[recognizer rac_signal] subscribeNext:^(UITapGestureRecognizer *sender){
        block();
    }];
}
@end
