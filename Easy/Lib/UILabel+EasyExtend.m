//
//  UILabel+EasyExtend.m
//  leway
//
//  Created by 朱潮 on 14-6-6.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "UILabel+EasyExtend.h"

@implementation UILabel (EasyExtend)

//ios6 later
-(CGSize)autoSize{
    return [self.text boundingRectWithSize:self.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
}
@end
