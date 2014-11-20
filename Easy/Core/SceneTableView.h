//
//  SceneTableView.h
//  fastSign
//
//  Created by EasyIOS on 14-4-12.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SVPullToRefresh.h"
#import "Pagination.h"

@interface SceneTableView : UITableView
@property(nonatomic,strong) UILabel *msgLabel;
@property(nonatomic,strong) Pagination *pagination;

-(void)flashMessage:(NSString *)msg;
-(void)endAllRefreshing;
@end
