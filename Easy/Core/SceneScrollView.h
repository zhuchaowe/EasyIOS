//
//  SceneScrollView.h
//  leway
//
//  Created by 朱潮 on 14-6-20.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "MJRefresh.h"
@protocol SceneScrollViewDelegate;
@interface SceneScrollView : UIScrollView
@property(nonatomic,strong)MJRefreshHeaderView *header;
@property(strong,nonatomic)NSString *cacheDataString;
@property(nonatomic,strong)UILabel *msgLabel;
@property (strong, nonatomic) id <SceneScrollViewDelegate> SceneDelegate;
-(void)addHeader;
-(void)flashMessage:(NSString *)msg;
-(void)endAllRefreshing;
@end

@protocol SceneScrollViewDelegate <NSObject>

@required
-(void)handlePullLoader:(MJRefreshBaseView *)view state:(PullLoaderState)state;
@end