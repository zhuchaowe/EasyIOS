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
    __weak EZNavigationController *weakSelf = self;
    self.popGestureRecognizerEnabled = YES;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] )
        self.interactivePopGestureRecognizer.enabled = NO;
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    // Enable the gesture again once the new controller is shown
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = self.popGestureRecognizerEnabled;
}

/*修复系统 push造成 crash http://www.cnblogs.com/lexingyu/p/3432444.html*/
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer == self.interactivePopGestureRecognizer){
        if(self.viewControllers.count <2 || self.visibleViewController == [self.viewControllers objectAtIndex:0]){
            return NO;
        }
    }
    return YES;
}
@end
