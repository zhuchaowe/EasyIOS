//
//  EzMiButton.h
//  leway
//
//  Created by 朱潮 on 14-6-28.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "EzUILabel.h"

typedef enum
{
    IMAGE_LEFT_FLOAT                    =0,
    IMAGE_RIGHT_FLOAT                   =1,
    IMAGE_LEFT_FIX                   =2,
    IMAGE_RIGHT_FIX                  =3,
    IMAGE_TOP                     =4,
    IMAGE_BOTTOM                  =5,
} EzMiButtonImagePosition;


@interface EzMiButton : UIButton
@property(nonatomic,retain)UIImageView *miImageView;
@property(nonatomic,retain)UILabel *miTextLabel;
@property (nonatomic,assign) EzMiButtonImagePosition miPosition;
@property(nonatomic,assign) NSUInteger spaceing;
-(void)setImage:(UIImage *)image;
-(void)setTitle:(NSString *)title fontSize:(CGFloat)size;
@end
