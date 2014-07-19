//
//  FontAwesome.m
//  FontAwesomeTools-iOS is Copyright 2013 TapTemplate and released under the MIT license.
//  www.taptemplate.com
//

#import "IconFont.h"
#import <CoreText/CoreText.h>
@implementation IconFont


//================================
// Font and Label Methods
//================================

+ (void)registerIconFontWithURL:(NSURL *)url
{
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[url path]], @"Font file doesn't exist");
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CFErrorRef error;
    CTFontManagerRegisterGraphicsFont(newFont, &error);
    CGFontRelease(newFont);
}

+(void)loadFontList{
    NSDictionary *fontDict = [NSDictionary objectFromData:[NSData fromResource:@"fontIconConfig.json"]];
    NSArray *fontList = [fontDict allValues];
    #ifndef DISABLE_FOUNDATIONICONS_AUTO_REGISTRATION
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            for (NSDictionary *resDict in fontList) {
                NSString *  resName = [resDict objectForKey:@"ttf"];
                NSString *	extension = [resName pathExtension];
                NSString *	fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
                [self registerIconFontWithURL: [[NSBundle mainBundle] URLForResource:fullName withExtension:extension]];
            }
        });
    #endif
}

+(NSString *)icon:(NSString *)iconName fromFont:(NSString *)fontName{
    [self loadFontList];
    NSDictionary *fontDict = [NSDictionary objectFromData:[NSData fromResource:@"fontIconConfig.json"]];
    NSString *json = [[fontDict objectForKey:fontName] objectForKey:@"json"];
    NSDictionary *dict = [NSDictionary objectFromData:[NSData fromResource:json]];
    NSString *icon = nil;
    if([dict objectForKey:iconName]){
        icon = [dict objectForKey:iconName];
    }
    return icon;
}

+ (UIFont*)font:(NSString *)fontName withSize:(CGFloat)size
{
    return [UIFont fontWithName:fontName size:size];
}

+ (UILabel*)labelWithIcon:(NSString*)fa_icon
                    fontName:(NSString *)name
                     size:(CGFloat)size
                    color:(UIColor*)color
{
    UILabel *label = [[UILabel alloc] init];
    [IconFont label:label fontName:name setIcon:fa_icon size:size color:color sizeToFit:YES];
    return label;
}

+ (void)label:(UILabel*)label
     fontName:(NSString *)name
      setIcon:(NSString*)fa_icon
         size:(CGFloat)size
        color:(UIColor*)color
    sizeToFit:(BOOL)shouldSizeToFit
{
    label.font = [IconFont font:name withSize:size];
    label.text = fa_icon;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    if (shouldSizeToFit) {
        [label sizeToFit];
    }
    // NOTE: FontAwesome icons will be silent through VoiceOver, but the Label is still selectable through VoiceOver. This can cause a usability issue because a visually impaired user might navigate to the label but get no audible feedback that the navigation happened. So hide the label for VoiceOver by default - if your label should be descriptive, un-hide it explicitly after creating it, and then set its accessibiltyLabel.
    label.accessibilityElementsHidden = YES;
}

+ (UIButton*)buttonWithIcon:(NSString*)fa_icon
                   fontName:(NSString *)name
                     size:(CGFloat)size
                    color:(UIColor*)color
{
    UIButton *button = [[UIButton alloc] init];
    [IconFont button:button fontName:name setIcon:fa_icon size:size color:color];
    return button;
}

+ (void)button:(UIButton *)button
        fontName:(NSString *)name
      setIcon:(NSString*)fa_icon
         size:(CGFloat)size
        color:(UIColor*)color
{
    button.titleLabel.font = [IconFont font:name withSize:size];
    [button setTitle:fa_icon forState:UIControlStateNormal];
    [button setTitle:fa_icon forState:UIControlStateSelected];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button sizeToFit];
}

//================================
// Image Methods
//================================

+ (UIImage*)imageWithIcon:(NSString*)fa_icon
                fontName:(NSString *)name
                iconColor:(UIColor*)iconColor
                 iconSize:(CGFloat)iconSize
{
    return [IconFont imageWithIcon:fa_icon
                            fontName:(NSString *)name
                            iconColor:iconColor
                             iconSize:iconSize
                            imageSize:CGSizeMake(iconSize, iconSize)];
}

+ (UIImage*)imageWithIcon:(NSString*)fa_icon
                 fontName:(NSString *)name
                iconColor:(UIColor*)iconColor
                 iconSize:(CGFloat)iconSize
                imageSize:(CGSize)imageSize;
{
    NSAssert(fa_icon, @"You must specify an icon from font-awesome-codes.h.");
    return [self imageWithText:fa_icon
                          font:[IconFont font:name withSize:iconSize]
                     iconColor:iconColor
                     imageSize:imageSize];
}

+ (UIImage*)imageWithText:(NSString*)characterCodeString
                     font:(UIFont*)font
                iconColor:(UIColor*)iconColor
                imageSize:(CGSize)imageSize;
{
    NSAssert(characterCodeString, @"You must specify a character code, such as \\uf190.");

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
        if (!iconColor) { iconColor = [UIColor blackColor]; }
        
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
        NSAttributedString* attString = [[NSAttributedString alloc]
                                         initWithString:characterCodeString
                                         attributes:@{NSFontAttributeName: font,
                                                      NSForegroundColorAttributeName : iconColor}];
        // get the target bounding rect in order to center the icon within the UIImage:
        NSStringDrawingContext *ctx = [[NSStringDrawingContext alloc] init];
        CGRect boundingRect = [attString boundingRectWithSize:CGSizeMake(font.pointSize, font.pointSize) options:0 context:ctx];
        // draw the icon string into the image:
        [attString drawInRect:CGRectMake((imageSize.width/2.0f) - boundingRect.size.width/2.0f,
                                         (imageSize.height/2.0f) - boundingRect.size.height/2.0f,
                                         imageSize.width,
                                         imageSize.height)];
        UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return iconImage;
    } else {
#if DEBUG
        NSLog(@" [ FontAwesomeTools ] Using lower-res iOS 5-compatible image rendering.");
#endif
        UILabel *iconLabel = [IconFont labelWithIcon:characterCodeString fontName:font.fontName size:font.pointSize color:iconColor];
        UIImage *iconImage = nil;
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 1.0);
        {
            CGContextRef imageContext = UIGraphicsGetCurrentContext();
            if (imageContext != NULL) {
                UIGraphicsPushContext(imageContext);
                {
                    CGContextTranslateCTM(imageContext,
                                          (imageSize.width/2.0f) - iconLabel.frame.size.width/2.0f,
                                          (imageSize.height/2.0f) - iconLabel.frame.size.height/2.0f);
                    [[iconLabel layer] renderInContext: imageContext];
                }
                UIGraphicsPopContext();
            }
            iconImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
        return iconImage;
    }
}

// DEPRECATED - Instead use +imageWithIcon:iconColor:iconSize:
+ (UIImage*)imageWithIcon:(NSString*)fa_icon fontName:(NSString *)name size:(CGFloat)size color:(UIColor*)color
{
    return [IconFont imageWithIcon:fa_icon fontName:name iconColor:color iconSize:size imageSize:CGSizeMake(size, size)];
}


@end
