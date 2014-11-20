//
//  SceneTableView.m
//  fastSign
//
//  Created by EasyIOS on 14-4-12.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SceneTableView.h"

@implementation SceneTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
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
    if(self.pullToRefreshView !=nil){
        [self.pullToRefreshView stopAnimating];
    }
    if(self.infiniteScrollingView !=nil){
        if(self.pagination.isEnd.integerValue == 1){
          [self.infiniteScrollingView setEnded];
        }else{
           [self.infiniteScrollingView stopAnimating];
        }
    }
}
@end
