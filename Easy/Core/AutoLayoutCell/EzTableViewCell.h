//
//  EzTableViewCell.h
//  mcapp
//
//  Created by zhuchao on 14/12/31.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EzTableViewCell : UITableViewCell
/**
 *  Subclasses should use this method for common setup (`init`) code.
 *
 * @discussion The default implementation registers for `UIContentSizeCategoryDidChangeNotification` notifications. This method is called by all `init` methods after `self` has already been initialized.
 */
- (void)commonInit __attribute((objc_requires_super));

-(void)reloadData:(id)entity;
-(void)reloadData:(id)entity sender:(id)sender;
@end
