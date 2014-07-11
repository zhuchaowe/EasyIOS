//
//  SceneScrollView.m
//  leway
//
//  Created by 朱潮 on 14-6-20.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SceneScrollView.h"

@implementation SceneScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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

-(void)endAllRefreshing{
    if(_header !=nil){
        [_header endRefreshing];
    }
}

@end
