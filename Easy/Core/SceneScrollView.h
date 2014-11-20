//
//  SceneScrollView.h
//  leway
//
//  Created by 朱潮 on 14-6-20.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SVPullToRefresh.h"
@interface SceneScrollView : UIScrollView
@property(nonatomic,strong)UILabel *msgLabel;
-(void)flashMessage:(NSString *)msg;
-(void)endAllRefreshing;
@end