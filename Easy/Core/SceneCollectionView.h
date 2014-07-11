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
@property(nonatomic,assign)NSUInteger page;
@property(nonatomic,assign)NSUInteger pageSize;
@property(nonatomic,assign)NSUInteger total;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(nonatomic,strong)NSString *cacheDataString;
@property(nonatomic,strong)UILabel *msgLabel;
@property (strong, nonatomic) id <SceneCollectionViewDelegate> SceneDelegate;
-(void)addHeader;
-(void)addFooter;
-(void)flashMessage:(NSString *)msg;
-(void)successWithNewArray:(NSArray *)array;
-(void)endAllRefreshing;
@end

@protocol SceneCollectionViewDelegate <NSObject>

@required
-(void)handlePullLoader:(MJRefreshBaseView *)view state:(NSInteger)state;

@end
