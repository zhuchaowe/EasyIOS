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

+ (UIImage*)gaussBlur:(CGFloat)blurLevel andImage:(UIImage*)originImage
{
    blurLevel = MIN(1.0,MAX(0.0, blurLevel));
    //int boxSize = (int)(blurLevel * 0.1 * MIN(self.size.width, self.size.height));
    int boxSize = 50;//模糊度。
    boxSize = boxSize - (boxSize % 2) + 1;
    NSData *imageData = UIImageJPEGRepresentation(originImage, 1);
    UIImage *tmpImage = [UIImage imageWithData:imageData];
    CGImageRef img = tmpImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *CGImageGetHeight(img));
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    NSInteger windowR = boxSize/2;
    CGFloat sig2 = windowR / 3.0;
    if(windowR>0){ sig2 = -1/(2*sig2*sig2); }
    int16_t *kernel = (int16_t*)malloc(boxSize*sizeof(int16_t));
    int32_t  sum = 0;
    for(NSInteger i=0; i<boxSize; ++i){
        kernel[i] = 255*exp(sig2*(i-windowR)*(i-windowR));
        sum += kernel[i];
    }
    free(kernel);
    // convolution
    error = vImageConvolve_ARGB8888(&inBuffer, &outBuffer,NULL, 0, 0, kernel, boxSize, 1, sum, NULL, kvImageEdgeExtend);
    error = vImageConvolve_ARGB8888(&outBuffer, &inBuffer,NULL, 0, 0, kernel, 1, boxSize, sum, NULL, kvImageEdgeExtend);
    outBuffer = inBuffer;
    if (error) {
        //NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGBitmapAlphaInfoMask &kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef =CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    return returnImage;
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
+(void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
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
