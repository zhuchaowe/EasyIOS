//
//  ImageTool.h
//  Schedule
//
//  Created by 石建交 on 14-1-30.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ImageTool : NSObject
+ (ImageTool *)sharedInstance;
//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToWidth:(CGFloat)newWidth;
+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
+ (NSString *)saveData:(NSData *)data WithName:(NSString *)imageName;
+ (void)savePhotosAlbum:(UIImage *)image;
+(void)deleteFileFromPath:(NSString *)path;
+(UIImage *)imageFromString:(NSString *)string inRect:(CGRect)rect;
@end
