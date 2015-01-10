//
//  EzTableViewCell.m
//  mcapp
//
//  Created by zhuchao on 14/12/31.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "EzTableViewCell.h"

@implementation EzTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}


-(void)reloadData:(id)entity{

}

-(void)reloadData:(id)entity sender:(id)sender{

}

@end
