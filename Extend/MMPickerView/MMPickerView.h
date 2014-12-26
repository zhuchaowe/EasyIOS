//
//  MMPickerView.h
//  MMPickerView
//
//  Created by Madjid Mahdjoubi on 6/5/13.
//  Copyright (c) 2013 GG. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const MMbackgroundColor;
extern NSString * const MMtextColor;
extern NSString * const MMtoolbarColor;
extern NSString * const MMbuttonColor;
extern NSString * const MMfont;
extern NSString * const MMvalueY;
extern NSString * const MMselectedObject;
extern NSString * const MMtoolbarBackgroundImage;

@interface MMPickerView: UIView

+(void)showPickerViewInView: (UIView *)view
                withStrings: (NSArray *)strings
                withOptions: (NSDictionary *)options
                 completion: (void(^)(NSArray *selectedString))completion;

+(void)showPickerViewInView: (UIView *)view
                withStrings: (NSArray *)strings
                withOptions: (NSDictionary *)options
                   selected: (void(^)(MMPickerView *mmPickView,NSInteger row,NSInteger component))selected
                 completion: (void(^)(NSArray *selectedString))completion;

-(void)reloadAllComponentWithPickViewArray:(NSArray *)array;
-(void)reloadComponent:(NSInteger)component withPickViewArray:(NSArray *)array;

+(void)dismissWithCompletion: (void(^)(NSArray *))completion;

@end
