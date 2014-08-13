//
//  EzMiButton.m
//  leway
//
//  Created by 朱潮 on 14-6-28.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "EzMiButton.h"
#import "EzUITapGestureRecognizer.h"

@implementation EzMiButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _spaceing = 5;
        _miPosition = IMAGE_LEFT_FIX;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_miImageView !=nil && _miTextLabel !=nil) {
        CGRect imageFrame =  _miImageView.frame;
        CGRect labelFrame = _miTextLabel.frame;
        
        if(_miPosition == IMAGE_RIGHT_FLOAT){
            labelFrame.origin.x = _spaceing;
            imageFrame.origin.x = labelFrame.size.width +2*_spaceing;
            _miTextLabel.textAlignment = NSTextAlignmentRight;
            CGFloat height = labelFrame.size.height > imageFrame.size.height ? labelFrame.size.height:imageFrame.size.height;
            labelFrame.size.height = imageFrame.size.height = height;
            imageFrame.origin.y = labelFrame.origin.y = (self.height - height)/2;
        }else if(_miPosition == IMAGE_RIGHT_FIX){
            labelFrame.size.width = self.width - imageFrame.size.width - 2*_spaceing;
            labelFrame.origin.x = 0;
            imageFrame.origin.x = labelFrame.size.width +_spaceing;
            _miTextLabel.textAlignment = NSTextAlignmentRight;
            CGFloat height = labelFrame.size.height > imageFrame.size.height ? labelFrame.size.height:imageFrame.size.height;
            labelFrame.size.height = imageFrame.size.height = height;
            imageFrame.origin.y = labelFrame.origin.y = (self.height - height)/2;
        }else if(_miPosition == IMAGE_TOP){
            labelFrame.origin.y = imageFrame.size.height +_spaceing;
            imageFrame.origin.y = 0;
            _miTextLabel.textAlignment = NSTextAlignmentCenter;
            CGFloat width = labelFrame.size.width > imageFrame.size.width ? labelFrame.size.width:imageFrame.size.width;
            labelFrame.size.width = imageFrame.size.width = width;
            imageFrame.origin.x = labelFrame.origin.x = (self.width - width)/2;
        }else if(_miPosition == IMAGE_BOTTOM){
            labelFrame.origin.y = 0;
            imageFrame.origin.y = labelFrame.size.height +_spaceing;
            _miTextLabel.textAlignment = NSTextAlignmentCenter;
            CGFloat width = labelFrame.size.width > imageFrame.size.width ? labelFrame.size.width:imageFrame.size.width;
            labelFrame.size.width = imageFrame.size.width = width;
            imageFrame.origin.x = labelFrame.origin.x = (self.width - width)/2;
        }else if(_miPosition == IMAGE_LEFT_FIX){
            labelFrame.size.width = self.width - imageFrame.size.width - 2*_spaceing;
            labelFrame.origin.x = imageFrame.size.width +2*_spaceing;
            imageFrame.origin.x = _spaceing;
            _miTextLabel.textAlignment = NSTextAlignmentLeft;
            CGFloat height = labelFrame.size.height > imageFrame.size.height ? labelFrame.size.height:imageFrame.size.height;
            labelFrame.size.height = imageFrame.size.height = height;
            imageFrame.origin.y = labelFrame.origin.y = (self.height - height)/2;
        }else if(_miPosition == IMAGE_LEFT_FLOAT){
            labelFrame.origin.x = self.width - labelFrame.size.width - _spaceing;
            imageFrame.origin.x = labelFrame.origin.x - imageFrame.size.width - 2*_spaceing;
            _miTextLabel.textAlignment = NSTextAlignmentLeft;
            
            CGFloat height = labelFrame.size.height > imageFrame.size.height ? labelFrame.size.height:imageFrame.size.height;
            labelFrame.size.height = imageFrame.size.height = height;
            imageFrame.origin.y = labelFrame.origin.y = (self.height - height)/2;
        }
        _miImageView.frame = imageFrame;
        _miTextLabel.frame = labelFrame;
    }
}

-(void)setImage:(UIImage *)image{
    if(_miImageView == nil){
        _miImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _miImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    _miImageView.image = image;
    _miImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [self addSubview:_miImageView];
}

-(void)setTitle:(NSString *)title fontSize:(CGFloat)size{
    if(_miTextLabel == nil){
        _miTextLabel = [[EzUILabel alloc]initWithFrame:CGRectZero];
    }
    _miTextLabel.text = title;
    _miTextLabel.font = [UIFont systemFontOfSize:size];
    CGSize cgsize = [_miTextLabel autoSize];
    _miTextLabel.frame = CGRectMake(0, 0, cgsize.width, cgsize.height);
    [self addSubview:_miTextLabel];
}

//- (void)addTarget:(id)target action:(SEL)action object:(id)object{
//    EzUITapGestureRecognizer *gesture = [[EzUITapGestureRecognizer alloc]initWithTarget:target action:action];
//    gesture.object = object;
//    [self addGestureRecognizer:gesture];
//}

@end
