//
//  HKNavigation.h
//  Hoko
//
//  Created by Hoko, S.A. on 23/07/14.
//  Copyright (c) 2015 Hoko, S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDMacros.h"

/**
 *  HKNavigation is a helper class which allows you to push, present and set view
 *  controllers taking basis on your view controller hierararchy. This only takes
 *  account UITabBarControllers, UINavigationControllers and Modal View Controllers
 *  in order to traverse the hierarchy. 
 *
 *  WARNING: If you have custom navigation you should use your own methods to push and present
 *  view controllers, this is only a helper class for common navigation based on Apple's default
 *  view controller hierarchies.
 *
 */
@interface URLNavigation : NSObject
+ (instancetype)navigation;
- (UIViewController*)currentViewController;
- (UINavigationController*)currentNavigationViewController;
/**
 *  setRootViewController: changes the root view controller of the AppDelegate's window.
 *
 *  @param viewController Your view controller (or hierarchy of).
 */
+ (void)setRootViewController:(UIViewController *)viewController;

/**
 *  pushViewController:animated: pushes a view controller inside a navigation controller.
 *  If your viewController is a navigation controller it replaces the rootViewController,
 *  otherwise it tries to push the viewController if the current view controller is a 
 *  UINavigationController, otherwise it creates it before pushing.
 *
 *  @param viewController Your view controller.
 *  @param animated       If you choose to animate the pushing of the viewController.
 */
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 *  pushViewController:animated:replace: pushes a view controller inside a navigation controller.
 *  If your viewController is a navigation controller it replaces the rootViewController,
 *  otherwise it tries to push the viewController if the current view controller is a
 *  UINavigationController, otherwise it creates it before pushing.
 *  The replace parameter locates the current view controller and replaces it if it is of
 *  the same class as the viewController parameter being passed, this exists to avoid
 *  two of the same view controller in a row.
 *
 *  @param viewController Your view controller.
 *  @param animated       If you choose to animate the pushing of the viewController.
 */
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated replace:(BOOL)replace;

/**
 *  presentViewController:animated: presents a view controller as a modal view controller,
 *  taking basis on the current view controller to present from.
 *
 *  @param viewController Your view controller.
 *  @param animated       If you choose to animate the presenting of the viewController.
 */
+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated;

+(void)dismissCurrentAnimated:(BOOL)animated;
+(void)dismissToSecondViewAnimated:(BOOL)animated;
@end
