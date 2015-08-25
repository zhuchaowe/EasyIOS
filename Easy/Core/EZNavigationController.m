//
//  EZNavigationController.m
//  mcapp
//
//  Created by zhuchao on 14/10/24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "EZNavigationController.h"

@interface EZNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation EZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configGestureRecognizer];
}


- (void)configGestureRecognizer
{
    //系统侧滑功能的实现者
    id target = self.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
    //禁掉系统的侧滑手势
    self.interactivePopGestureRecognizer.enabled = NO;
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - UIGestureRecognizerDelegate
//当手势发生时调用,返回NO拦截手势而不调用Action
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL result = NO;
    if (gestureRecognizer == self.interactivePopGestureRecognizer) return result;
    
    if (self.viewControllers.count == 1) {
        result = NO;
    }
    else if(self.popGestureRecognizerEnabled)
    {
        result = YES;
    }
    
    return result;
    
}

- (void)dealloc
{
    UIPanGestureRecognizer *pan = [self.view.gestureRecognizers firstObject];
    pan.delegate = nil;
    self.interactivePopGestureRecognizer.delegate = nil;
}

@end
