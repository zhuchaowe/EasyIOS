//
//  Pagination.h
//  mcapp
//
//  Created by zhuchao on 14/11/7.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Model.h"

@interface Pagination : Model
@property(nonatomic,retain)NSNumber *page;
@property(nonatomic,retain)NSNumber *pageSize;
@property(nonatomic,retain)NSNumber *total;
@property(nonatomic,retain)NSNumber *isEnd;
-(NSMutableArray *)success:(NSMutableArray *)originArray
                  newArray:(NSArray *)newArray;
@end
