//
//  SceneCollectionView.h
//  fastSign
//
//  Created by EasyIOS on 14-4-20.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SVPullToRefresh.h"
#import "Pagination.h"

@interface SceneCollectionView : UICollectionView
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)Pagination *pagination;
@property(nonatomic,strong)UILabel *msgLabel;

-(void)flashMessage:(NSString *)msg;
-(void)successWithNewArray:(NSArray *)array pagination:(Pagination *)pagination;
-(void)endAllRefreshing;
@end

