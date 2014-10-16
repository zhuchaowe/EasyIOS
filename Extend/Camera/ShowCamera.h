//
//  ShowCamera.h
//  mcapp
//
//  Created by zhuchao on 14-10-16.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPImageCropperViewController.h"

@protocol ShowCameraDelegate <NSObject>
-(void)showPickViewController:(UIImagePickerController *)viewController;
-(void)showCropperViewController:(VPImageCropperViewController *)viewController;
-(void)dismissViewController;
-(void)callBackPath:(NSString *)localPath;
@end

@interface ShowCamera : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,VPImageCropperDelegate>

-(instancetype)initWithParentView:(UIView *)view delegate:(id<ShowCameraDelegate>)delegate;
-(void)showCameraSheet;
@end
