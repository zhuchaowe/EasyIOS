//
//  FontAwesome.h
//  FontAwesomeTools-iOS is Copyright 2013 TapTemplate and released under the MIT license.
//  www.taptemplate.com
//

#import "Easy.h"
#import "FontHeader.h"
@interface IconFont : NSObject

//================================
// Font and Label Methods
//================================

+(NSString *)icon:(NSString *)iconName fromFont:(NSString *)fontName;

/*! Get the FontAwesome font.
 */
+ (UIFont*)font:(NSString *)fontName withSize:(CGFloat)size;

/*! Make a sized-to-fit UILabel containing an icon in the given font size and color.
 */
+ (UILabel*)labelWithIcon:(NSString*)fa_icon
                fontName:(NSString *)name
                     size:(CGFloat)size
                    color:(UIColor*)color;

/*! Adjust an existing UILabel to show a FontAwesome icon.
 */
+ (void)label:(UILabel*)label
        fontName:(NSString *)name
      setIcon:(NSString*)fa_icon
         size:(CGFloat)size
        color:(UIColor*)color
    sizeToFit:(BOOL)shouldSizeToFit;

+ (UIButton*)buttonWithIcon:(NSString*)fa_icon
                    fontName:(NSString *)name
                       size:(CGFloat)size
                      color:(UIColor*)color;

+ (void)button:(UIButton *)button
        fontName:(NSString *)name
       setIcon:(NSString*)fa_icon
          size:(CGFloat)size
         color:(UIColor*)color;
//================================
// Image Methods
//================================

/*! Create a UIImage with a FontAwesome icon, with the image and the icon the same size
 */
+ (UIImage*)imageWithIcon:(NSString*)fa_icon
                fontName:(NSString *)name
                iconColor:(UIColor*)iconColor
                 iconSize:(CGFloat)iconSize;

+(void)loadFontList;
/*! Create a UIImage with a FontAwesome icon, and specify a square size for the icon, which will be centered within the CGSize specified for the image itself.
 */
+ (UIImage*)imageWithIcon:(NSString*)fa_icon
                fontName:(NSString *)name
                iconColor:(UIColor*)color
                 iconSize:(CGFloat)iconSize
                imageSize:(CGSize)imageSize;

/*! The image and the icon inside it can be from a custom font:
 */
+ (UIImage*)imageWithText:(NSString*)characterCodeString
                     font:(UIFont*)font
                iconColor:(UIColor*)iconColor
                imageSize:(CGSize)imageSize;

/*! NOTE: This method is deprecated! Use -imageWithIcon:iconColor:iconSize: instead. It does exactly the same thing, but I got fed up with it not matching the phrasing of the second UIImage creation method.
 */
+ (UIImage*)imageWithIcon:(NSString*)fa_icon fontName:(NSString *)name size:(CGFloat)size color:(UIColor*)color __attribute__((deprecated));

@end
