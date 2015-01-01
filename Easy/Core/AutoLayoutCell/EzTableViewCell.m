//
//  EzTableViewCell.m
//  mcapp
//
//  Created by zhuchao on 14/12/31.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "EzTableViewCell.h"

@implementation EzTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

@end
