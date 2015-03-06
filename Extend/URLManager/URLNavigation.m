//
//  HKObserver.m
//  Hoko
//
//  Created by Hoko, S.A. on 23/07/14.
//  Copyright (c) 2015 Hoko, S.A. All rights reserved.
//

#import "URLNavigation.h"

@implementation URLNavigation

#pragma mark - Singleton
+ (instancetype)navigation
{
  static URLNavigation *_sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [URLNavigation new];
  });
  
  return _sharedInstance;
}

#pragma mark - Public Method
+ (void)setRootViewController:(UIViewController *)viewController
{
  [HKNavigation navigation].applicationDelegate.window.rootViewController = viewController;
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  [self pushViewController:viewController animated:animated replace:NO];
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated replace:(BOOL)replace
{
  // Check if viewController is a UINavigationController
  if([viewController isKindOfClass:[UINavigationController class]])
    [HKNavigation setRootViewController:viewController];
  else {
    // Check if a UINavigationController exists in the view controllers stack.
    UINavigationController *navigationController = [HKNavigation navigation].currentNavigationViewController;
    if (navigationController) {
      // In case it should replace, look for the last UIViewController on the UINavigationController, if it's of the same class, replace it with a new one.
      if (replace && [navigationController.viewControllers.lastObject isKindOfClass:[viewController class]]) {
        NSArray *viewControllers = [navigationController.viewControllers subarrayWithRange:NSMakeRange(0, navigationController.viewControllers.count-1)];
        [navigationController setViewControllers:[viewControllers arrayByAddingObject:viewController] animated:animated];
      } else {
        // Otherwise just push the new viewController
        [navigationController pushViewController:viewController animated:animated];
      }
    } else {
      // Create a new UINavigationController to use with the viewController
      navigationController = [[UINavigationController alloc]initWithRootViewController:viewController];
      [HKNavigation navigation].applicationDelegate.window.rootViewController = navigationController;
    }
  }
}

+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  // Look for the currentViewController
  UIViewController *currentViewController = [[HKNavigation navigation] currentViewController];
  if (currentViewController) {
    // Present viewController from currentViewcontroller
    [currentViewController presentViewController:viewController animated:animated completion:nil];
  } else {
    // Otherwise set the window rootViewController
    [HKNavigation navigation].applicationDelegate.window.rootViewController = viewController;
  }
}

#pragma mark - Private Methods
- (id<UIApplicationDelegate>)applicationDelegate
{
  return [UIApplication sharedApplication].delegate;
}

- (UIViewController*)currentViewController
{
  UIViewController* rootViewController = self.applicationDelegate.window.rootViewController;
  return [self currentViewControllerFrom:rootViewController];
}

- (UINavigationController*)currentNavigationViewController
{
  UIViewController* currentViewController = self.currentViewController;
  return currentViewController.navigationController;
}

- (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController
{
  if ([viewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController* navigationController = (UINavigationController *)viewController;
    return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
  } else if([viewController isKindOfClass:[UITabBarController class]]) {
    UITabBarController* tabBarController = (UITabBarController *)viewController;
    return [self currentViewControllerFrom:tabBarController.selectedViewController];
  } else if(viewController.presentedViewController != nil) {
    return [self currentViewControllerFrom:viewController.presentedViewController];
  } else {
    return viewController;
  }
}

@end
