//
//  UIView+EasyExtend.m
//  leway
//
//  Created by 朱潮 on 14-6-5.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "UIView+EasyExtend.h"

@implementation UIView (EasyExtend)

-(CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}
-(CGFloat)top{
    return self.frame.origin.y;
}
-(CGFloat)left{
    return self.frame.origin.x;
}
-(CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}
-(CGFloat)width{
    return self.frame.size.width;
}
-(CGFloat)height{
    return self.frame.size.height;
}
- (UIImage *)saveImageWithScale:(float)scale
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
