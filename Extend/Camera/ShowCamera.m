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
@property(nonatomic,assign)BOOL ifShouldCrop;
@end
@implementation ShowCamera


-(instancetype)initWithParentView:(UIView *)view delegate:(id<ShowCameraDelegate>)delegate{
    self = [self init];
    if (self) {
        _parentView = view;
        _cameraDelegate = delegate;
        _ratio = 0.7f;
        _scaledToWidth = 320.0f;
        self.ifShouldCrop = YES;
    }
    return self;
}

-(void)showCameraSheetWithOutCrop{
    self.ifShouldCrop = NO;
    [self showCameraSheet];
}

-(void)showCameraSheet{
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [self openCamera:UIImagePickerControllerSourceTypePhotoLibrary];
        return;
    }
    UIActionSheet *imageSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片",@"从相册选择", nil];
    imageSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [imageSheet showInView:_parentView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
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
        if (self.ifShouldCrop) {// 裁剪
            VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, _parentView.frame.size.width, _parentView.frame.size.width*_ratio) limitScaleRatio:3.0];
            imgEditorVC.delegate = self;
            [self.cameraDelegate showCropperViewController:imgEditorVC];
        }else{
            [self saveImage:portraitImg];
        }
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
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    [self.cameraDelegate dismissViewController];
}

- (void)saveImage:(UIImage *)image {
    UIImage *midImage = [ImageTool imageWithImageSimple:image scaledToWidth:self.scaledToWidth];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[[NSString stringWithFormat:@"%@",[NSDate date]] MD5]];
    [ImageTool saveImage:midImage WithName:imageName];
    NSString * localPath = [NSString stringWithFormat:@"%@/%@",[$ documentPath],imageName];
    [self.cameraDelegate callBackPath:localPath];
}

@end
