//
//  UIImage+ImageProcessing.m
//
//  Created by Vincent Saluzzo on 28/05/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "UIImage+EasyExtend.h"

@implementation UIImage (EasyExtend)

- (UIImage *) toGrayscale 
{
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, self.size.width * self.scale, self.size.height * self.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image
                                                 scale:self.scale 
                                           orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

- (UIImage *)tintWithColor:(UIColor *)tintColor 
{
    // Begin drawing
    CGRect aRect = CGRectMake(0.f, 0.f, self.size.width, self.size.height);
    CGImageRef alphaMask;
    
    //
    // Compute mask flipping image
    //
    {
        UIGraphicsBeginImageContext(aRect.size);        
        CGContextRef c = UIGraphicsGetCurrentContext(); 
        
        // draw image
        CGContextTranslateCTM(c, 0, aRect.size.height);
        CGContextScaleCTM(c, 1.0, -1.0);
        [self drawInRect: aRect];
        
        alphaMask = CGBitmapContextCreateImage(c);
        
        UIGraphicsEndImageContext();
    }
    
    //
    UIGraphicsBeginImageContext(aRect.size);
    
    // Get the graphic context
    CGContextRef c = UIGraphicsGetCurrentContext(); 
    
    // Draw the image
    [self drawInRect:aRect];
    
    // Mask
    CGContextClipToMask(c, aRect, alphaMask);
    
    // Set the fill color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextSetFillColorSpace(c, colorSpace);
    
    // Set the fill color
    CGContextSetFillColorWithColor(c, tintColor.CGColor);
    
    UIRectFillUsingBlendMode(aRect, kCGBlendModeNormal);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    
    
    // Release memory
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(alphaMask);
    
    return img;
}

+ (UIImage *) imageWithUrl:(NSString *)url{
    return [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
}

@end
