//
//  SceneGridView.h
//  leway
//
//  Created by 朱潮 on 14-6-25.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "MJRefresh.h"

@protocol SceneGridViewDelegate;
@interface SceneGridView : UIGridView
@property(nonatomic,strong)MJRefreshHeaderView *header;
@property(nonatomic,strong)MJRefreshFooterView *footer;
@property(nonatomic,assign)NSUInteger page;
@property(nonatomic,assign)NSUInteger pageSize;
@property(nonatomic,assign)NSUInteger total;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(nonatomic,strong)UILabel *msgLabel;
@property (strong, nonatomic) id <SceneGridViewDelegate> SceneDelegate;
-(void)addHeader;
-(void)addFooter;
-(void)flashMessage:(NSString *)msg;
-(void)successWithNewArray:(NSArray *)array;
-(void)endAllRefreshing;
@end

@protocol SceneGridViewDelegate <NSObject>

@required
-(void)handlePullLoader:(MJRefreshBaseView *)view state:(NSInteger)state;

@end
