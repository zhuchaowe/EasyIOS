//
//  SceneTableView.h
//  fastSign
//
//  Created by EasyIOS on 14-4-12.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "MJRefresh.h"
@protocol SceneTableViewDelegate;
@interface SceneTableView : UITableView
@property(nonatomic,strong)MJRefreshHeaderView *header;
@property(nonatomic,strong)MJRefreshFooterView *footer;
@property(nonatomic,assign)NSUInteger page;
@property(nonatomic,assign)NSUInteger pageSize;
@property(nonatomic,assign)NSUInteger total;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(nonatomic,strong)UILabel *msgLabel;
@property (strong, nonatomic) id <SceneTableViewDelegate> SceneDelegate;
-(void)addHeader;
-(void)addFooter;
-(void)flashMessage:(NSString *)msg;
-(void)successWithNewArray:(NSArray *)array;
-(void)endAllRefreshing;
@end

@protocol SceneTableViewDelegate <NSObject>

@required
-(void)handlePullLoader:(MJRefreshBaseView *)view state:(NSInteger)state;

@end