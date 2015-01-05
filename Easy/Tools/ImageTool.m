//
//  ImageTool.m
//  Schedule
//
//  Created by 石建交 on 14-1-30.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "ImageTool.h"
#import<Accelerate/Accelerate.h>
@implementation ImageTool

+ (ImageTool *)sharedInstance
{
    static dispatch_once_t pred;
    static ImageTool *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToWidth:(CGFloat)newWidth
{
    CGFloat newHeight = newWidth * image.size.height/image.size.width;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

#pragma mark 保存图片到document
+(NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    return [self saveData:imageData WithName:imageName];
}

+(NSString *)saveData:(NSData *)data WithName:(NSString *)imageName
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [data writeToFile:fullPathToFile atomically:NO];
    return [NSString stringWithFormat:@"%@/%@",[$ documentPath],imageName];
}


+ (void)savePhotosAlbum:(UIImage *)image {
	UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}
+(void)deleteFileFromPath:(NSString *)path{
    NSFileManager *defaultManager;
    defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:path error:nil];
}
+(UIImage *)imageFromString:(NSString *)string inRect:(CGRect)rect {
    UIImage *image = [UIImage imageWithContentsOfFile:string];
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}


@end
