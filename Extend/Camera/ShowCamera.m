//
//  ShowCamera.m
//  mcapp
//
//  Created by zhuchao on 14-10-16.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "ShowCamera.h"
@interface ShowCamera()
@property(nonatomic,retain)UIView *parentView;
@property(nonatomic,weak)id<ShowCameraDelegate> cameraDelegate;
@end
@implementation ShowCamera


-(instancetype)initWithParentView:(UIView *)view delegate:(id<ShowCameraDelegate>)delegate{
    self = [self init];
    if (self) {
        _parentView = view;
        _cameraDelegate = delegate;
    }
    return self;
}

-(void)showCameraSheet{
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [self openCamera:UIImagePickerControllerSourceTypePhotoLibrary];
        return;
    }
    UIActionSheet *imageSheet = [[UIActionSheet alloc] initWithTitle:@"修改图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片",@"从相册选择", nil];
    imageSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [imageSheet showInView:_parentView];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self openCamera:UIImagePickerControllerSourceTypeCamera];
    }else if (buttonIndex == 1) {
        [self openCamera:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)openCamera:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    [self.cameraDelegate showPickViewController:picker];
}

#pragma mark –
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        portraitImg = [portraitImg imageByScalingToMaxSize];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, _parentView.frame.size.width, _parentView.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self.cameraDelegate showCropperViewController:imgEditorVC];
    }];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [self saveImage:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.cameraDelegate dismissViewController];
}

- (void)saveImage:(UIImage *)image {
    UIImage *midImage = [ImageTool imageWithImageSimple:image scaledToWidth:100.0f];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[[NSString stringWithFormat:@"%@",[NSDate date]] MD5]];
    [ImageTool saveImage:midImage WithName:imageName];
    NSString * localPath = [NSString stringWithFormat:@"%@/%@",[$ documentPath],imageName];
    [self.cameraDelegate callBackPath:localPath];
}

@end
