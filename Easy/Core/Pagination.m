//
//  Pagination.m
//  mcapp
//
//  Created by zhuchao on 14/11/7.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Pagination.h"

@implementation Pagination

-(void)loadModel{
    self.page = @1;
    self.pageSize = @10;
    self.total = @0;
    self.isEnd = @1;
}

-(NSMutableArray *)success:(NSMutableArray *)originArray
                  newArray:(NSArray *)newArray{
    if (self.page.integerValue == 1) {
        [originArray removeAllObjects];
        originArray = [NSMutableArray array];
    }
    if([newArray count]>0){
        [originArray addObjectsFromArray:newArray];
    }
    return originArray;
}
@end
