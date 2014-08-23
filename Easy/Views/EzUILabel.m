//
//  EzUILabel.m
//  leway
//
//  Created by 朱潮 on 14-6-7.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "EzUILabel.h"

@interface EzUILabel()
{
	BOOL	_inited;
}

- (void)initSelf;

@end

@implementation EzUILabel

- (id)init
{
	self = [super initWithFrame:CGRectZero];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (void)initSelf
{
	if ( NO == _inited )
	{
		self.backgroundColor = [UIColor clearColor];
		self.font = [UIFont systemFontOfSize:12.0f];
		self.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		self.textColor = [UIColor whiteColor];
		self.backgroundColor = [UIColor clearColor];
		self.lineBreakMode = NSLineBreakByTruncatingTail;
		self.isWithStrikeThrough = NO;
        _inited = YES;
	}
}

- (void)drawRect:(CGRect)rect
{
    if (_isWithStrikeThrough)
    {
        CGSize contentSize = [self.text sizeWithFont:self.font constrainedToSize:self.frame.size];
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGFloat color[4] = {0.667, 0.667, 0.667, 1.0};
        CGContextSetStrokeColor(c, color);
        CGContextSetLineWidth(c, 1);
        CGContextBeginPath(c);
        CGFloat halfWayUp = (self.bounds.size.height - self.bounds.origin.y) / 2.0;
        CGContextMoveToPoint(c, self.bounds.origin.x, halfWayUp );
        CGContextAddLineToPoint(c, self.bounds.origin.x + contentSize.width, halfWayUp);
        CGContextStrokePath(c);
    }
    
    [super drawRect:rect];
}
@end
