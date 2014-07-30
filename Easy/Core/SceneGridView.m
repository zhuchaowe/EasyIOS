//
//  SceneGridView.m
//  leway
//
//  Created by 朱潮 on 14-6-25.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SceneGridView.h"

@implementation SceneGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)initPage{
    _page = @1;
    _pageSize = @10;
    _total = @0;
}
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self;
    footer.refreshStateChangeBlock =^(MJRefreshBaseView *refreshView,MJRefreshState state) {
        if(state == MJRefreshStateRefreshing){
            [_SceneDelegate handlePullLoader:refreshView state:REACH_BOTTOM];
        }
    };
    _footer = footer;
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self;
    header.refreshStateChangeBlock =^(MJRefreshBaseView *refreshView,MJRefreshState state) {
        if(state == MJRefreshStateRefreshing){
            [_SceneDelegate handlePullLoader:refreshView state:HEADER_REFRESH];
        }
    };
    _header = header;
}

- (void)flashMessage:(NSString *)msg {
	//Show message
	__block CGRect rect = CGRectMake(0, - 20, self.bounds.size.width, 20);
    
	if (_msgLabel == nil) {
		_msgLabel = [[UILabel alloc] init];
		_msgLabel.frame = rect;
		_msgLabel.font = [UIFont systemFontOfSize:14.f];
		_msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_msgLabel.backgroundColor = [UIColor redColor];
        _msgLabel.textColor = [UIColor whiteColor];
		_msgLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_msgLabel];
	}
	_msgLabel.text = msg;
    
	rect.origin.y += 20;
	[UIView animateWithDuration:.4f animations: ^{
	    _msgLabel.frame = rect;
	} completion: ^(BOOL finished) {
	    rect.origin.y -= 20;
	    [UIView animateWithDuration:.4f delay:1.2f options:UIViewAnimationOptionCurveLinear animations: ^{
	        _msgLabel.frame = rect;
		} completion: ^(BOOL finished) {
	        [_msgLabel removeFromSuperview];
	        _msgLabel = nil;
		}];
	}];
}
-(void)successWithNewArray:(NSArray *)array{
    if ([_page integerValue] == 1) {
        [_dataArray removeAllObjects];
        _dataArray = [NSMutableArray array];
    }
    if([array count]>0){
        [_dataArray addObjectsFromArray:array];
    }
    [self endAllRefreshing];
}
-(void)endAllRefreshing{
    if(_header !=nil){
        [_header endRefreshing];
    }
    if(_footer !=nil){
        if([_page integerValue] == 1){
            _footer.isEnd = NO;
        }
        if([_total integerValue] >0 && [_total integerValue] == [self.dataArray count] && _footer.isEnd == NO){
            [self.footer setState:MJRefreshStateEnd];
        }else {
            if(_footer.isEnd == NO){
                [_footer endRefreshing];
            }
        }
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([self.SceneDelegate respondsToSelector:@selector(sceneGridViewDidScroll:)]){
        [self.SceneDelegate sceneGridViewDidScroll:scrollView];
    }
}
@end
