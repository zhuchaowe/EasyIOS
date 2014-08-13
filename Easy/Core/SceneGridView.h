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
@interface SceneGridView : UIGridView<UIScrollViewDelegate>
@property(nonatomic,strong)MJRefreshHeaderView *header;
@property(nonatomic,strong)MJRefreshFooterView *footer;
@property(nonatomic,strong)NSNumber *page;
@property(nonatomic,strong)NSNumber *pageSize;
@property(nonatomic,strong)NSNumber *total;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)NSString *cacheDataString;
@property(nonatomic,strong)UILabel *msgLabel;
@property (strong, nonatomic) id <SceneGridViewDelegate> SceneDelegate;
-(void)addHeader;
-(void)addFooter;
-(void)initPage;
-(void)flashMessage:(NSString *)msg;
-(void)successWithNewArray:(NSArray *)array;
-(void)endAllRefreshing;
@end

@protocol SceneGridViewDelegate <NSObject>

@required
-(void)handlePullLoader:(MJRefreshBaseView *)view state:(PullLoaderState)state;
@optional
- (void) sceneGridViewDidScroll:(UIScrollView *)scrollView;
@end
