//
//  UIImage+ImageProcessing.m
//
//  Created by Vincent Saluzzo on 28/05/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "UIImage+EasyExtend.h"
#import<Accelerate/Accelerate.h>
#define ORIGINAL_MAX_WIDTH 640.0f

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

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1,1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,1.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)resizableImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    CGFloat minEdgeSize = cornerRadius * 2 + 1;
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}


- (UIImage *)imageByScalingToMaxSize {
    if (self.size.width < ORIGINAL_MAX_WIDTH) return self;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (self.size.width > self.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = self.size.width * (ORIGINAL_MAX_WIDTH / self.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = self.size.height * (ORIGINAL_MAX_WIDTH / self.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingToSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingToSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage*)applyLightEffect
{
    UIColor*tintColor =[UIColor colorWithWhite:1.0 alpha:0.3];
    return[self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)applyExtraLightEffect
{
    UIColor*tintColor =[UIColor colorWithWhite:0.97 alpha:0.82];
    return[self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)applyDarkEffect
{
    UIColor*tintColor =[UIColor colorWithWhite:0.11 alpha:0.73];
    return[self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)applyTintEffectWithColor:(UIColor*)tintColor
{
    const CGFloat EffectColorAlpha=0.6;
    UIColor*effectColor = tintColor;
    int componentCount =CGColorGetNumberOfComponents(tintColor.CGColor);
    if(componentCount ==2){
        CGFloat b;
        if([tintColor getWhite:&b alpha:NULL]){
            effectColor =[UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else{
        CGFloat r, g, b;
        if([tintColor getRed:&r green:&g blue:&b alpha:NULL]){
            effectColor =[UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return[self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}
-(UIImage*)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage
{
    // Check pre-conditions.
    if(self.size.width <1||self.size.height <1){
        NSLog(@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@",self.size.width,self.size.height,self);
        return nil;
    }
    if(!self.CGImage){
        NSLog(@"*** error: image must be backed by a CGImage: %@",self);
        return nil;
    }
    if(maskImage &&!maskImage.CGImage){
        NSLog(@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    CGRect imageRect ={CGPointZero,self.size };
    UIImage*effectImage =self;
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor -1.)> __FLT_EPSILON__;
    if(hasBlur || hasSaturationChange){
        UIGraphicsBeginImageContextWithOptions(self.size, NO,[[UIScreen mainScreen] scale]);
        CGContextRef effectInContext =UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext,1.0,-1.0);
        CGContextTranslateCTM(effectInContext,0,-self.size.height);
        CGContextDrawImage(effectInContext, imageRect,self.CGImage);
        vImage_Buffer effectInBuffer;
        effectInBuffer.data =CGBitmapContextGetData(effectInContext);
        effectInBuffer.width =CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height =CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes =CGBitmapContextGetBytesPerRow(effectInContext);
        UIGraphicsBeginImageContextWithOptions(self.size, NO,[[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext =UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data =CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width =CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height =CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes =CGBitmapContextGetBytesPerRow(effectOutContext);
        if(hasBlur){
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius *[[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius *3.* sqrt(2* M_PI)/4+0.5);
            if(radius %2!=1){
                radius +=1;// force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer,&effectOutBuffer, NULL,0,0, radius, radius,0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer,&effectInBuffer, NULL,0,0, radius, radius,0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer,&effectOutBuffer, NULL,0,0, radius, radius,0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if(hasSaturationChange){
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[]={
                0.0722+0.9278* s,0.0722-0.0722* s,0.0722-0.0722* s,0,
                0.7152-0.7152* s,0.7152+0.2848* s,0.7152-0.7152* s,0,
                0.2126-0.2126* s,0.2126-0.2126* s,0.2126+0.7873* s,0,
                0,0,0,1,
            };
            const int32_t divisor =256;
            NSUInteger matrixSize =sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for(NSUInteger i =0; i < matrixSize;++i){
                saturationMatrix[i]=(int16_t)roundf(floatingPointSaturationMatrix[i]* divisor);
            }
            if(hasBlur){
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer,&effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else{
                vImageMatrixMultiply_ARGB8888(&effectInBuffer,&effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if(!effectImageBuffersAreSwapped)
            effectImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if(effectImageBuffersAreSwapped)
            effectImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO,[[UIScreen mainScreen] scale]);
    CGContextRef outputContext =UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext,1.0,-1.0);
    CGContextTranslateCTM(outputContext,0,-self.size.height);
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect,self.CGImage);
    // Draw effect image.
    if(hasBlur){
        CGContextSaveGState(outputContext);
        if(maskImage){
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    // Add in color tint.
    if(tintColor){
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    // Output image is ready.
    UIImage*outputImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

+ (UIImage *) imageFromData: (NSString *) imgSrc
{
    if ([imgSrc hasPrefix:@"data:"]) {
        NSArray *array = [imgSrc componentsSeparatedByString:@"base64,"];
        NSData *data = [[NSData alloc]initWithBase64EncodedString:[array objectAtIndex:1] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        return [UIImage imageWithData:data];
    }else if([imgSrc hasPrefix:@"http://"] || [imgSrc hasPrefix:@"https://"] ){
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgSrc]]];
    }else if([UIImage imageNamed:imgSrc]){
        return [UIImage imageNamed:imgSrc];
    }else{
        return nil;
    }
}

- (BOOL) imageHasAlpha
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

- (NSString *) image2DataURL
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha]) {
        imageData = UIImagePNGRepresentation(self);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(self, 1.0f);
        mimeType = @"image/jpeg";
    }
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions:0]];
}
@end
