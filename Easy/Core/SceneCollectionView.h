//
//  SceneCollectionView.h
//  fastSign
//
//  Created by EasyIOS on 14-4-20.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "MJRefresh.h"
@protocol SceneCollectionViewDelegate;
@interface SceneCollectionView : UICollectionView
@property(nonatomic,strong)MJRefreshHeaderView *header;
@property(nonatomic,strong)MJRefreshFooterView *footer;
@property(nonatomic,retain)NSNumber *page;
@property(nonatomic,retain)NSNumber *pageSize;
@property(nonatomic,retain)NSNumber *total;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(nonatomic,strong)NSString *cacheDataString;
@property(nonatomic,strong)UILabel *msgLabel;
@property(strong, nonatomic)id <SceneCollectionViewDelegate> SceneDelegate;
-(void)addHeader;
-(void)addFooter;
-(void)initPage;
-(void)flashMessage:(NSString *)msg;
-(void)successWithNewArray:(NSArray *)array;
-(void)endAllRefreshing;
@end

@protocol SceneCollectionViewDelegate <NSObject>

@required
-(void)handlePullLoader:(MJRefreshBaseView *)view state:(PullLoaderState)state;

@end
