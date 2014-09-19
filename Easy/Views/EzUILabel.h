//
//  EzUILabel.h
//  leway
//
//  Created by 朱潮 on 14-6-7.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Easy.h"
#import "TTTAttributedLabel.h"
@interface EzUILabel : TTTAttributedLabel
@property(nonatomic,assign)CGFloat letterSpacing;
@property(nonatomic,assign)BOOL isWithStrikeThrough;
-(void)setEzText:(NSString *)text;
@end
