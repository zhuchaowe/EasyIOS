//
//  UILabel+EasyExtend.m
//  leway
//
//  Created by 朱潮 on 14-6-6.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "UILabel+EasyExtend.h"

@implementation UILabel (EasyExtend)

-(CGSize)autoSize{
    return [self.text sizeWithFont:self.font constrainedToSize:self.frame.size lineBreakMode:NSLineBreakByWordWrapping];
}
@end
