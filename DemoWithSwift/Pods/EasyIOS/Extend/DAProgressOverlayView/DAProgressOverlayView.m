//
//  DAProgressOverlayView.m
//  DAProgressOverlayView
//
//  Created by Daria Kopaliani on 8/1/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import "DAProgressOverlayView.h"

typedef enum {
    DAProgressOverlayViewStateWaiting = 0,
    DAProgressOverlayViewStateOperationInProgress = 1,
    DAProgressOverlayViewStateOperationFinished = 2
} DAProgressOverlayViewState;

@interface DAProgressOverlayView ()

@property (assign, nonatomic) DAProgressOverlayViewState state;
@property (assign, nonatomic) CGFloat animationProggress;
@property (strong, nonatomic) NSTimer *timer;

@end


CGFloat const DAUpdateUIFrequency = 1. / 25.;


@implementation DAProgressOverlayView

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor clearColor];
    self.progress = 0.;
    self.outerRadiusRatio = 0.7;
    self.innerRadiusRatio = 0.6;
    self.overlayColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];
    self.animationProggress = 0.;
    self.stateChangeAnimationDuration = 0.25;
    self.triggersDownloadDidFinishAnimationAutomatically = YES;
}

#pragma mark - Public

- (void)displayOperationDidFinishAnimation
{
    self.state = DAProgressOverlayViewStateOperationFinished;
    self.animationProggress = 0.;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:DAUpdateUIFrequency target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)displayOperationWillTriggerAnimation
{
    self.state = DAProgressOverlayViewStateWaiting;
    self.animationProggress = 0.;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:DAUpdateUIFrequency target:self selector:@selector(update) userInfo:nil repeats:YES];
}

#pragma mark * Overwritten methods

- (void)drawRect:(CGRect)rect
{
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    CGFloat outerRadius = [self outerRadius];
    CGFloat innerRadius = [self innerRadius];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, width / 2., height / 2.);
    CGContextScaleCTM(context, 1., -1.);
    CGContextSetRGBFillColor(context, 0., 0., 0., 0.5);
    CGContextSetFillColorWithColor(context, self.overlayColor.CGColor);
    
    CGMutablePathRef path0 = CGPathCreateMutable();
    CGPathMoveToPoint(path0, NULL, width / 2., 0.);
    CGPathAddLineToPoint(path0, NULL, width / 2., height / 2.);
    CGPathAddLineToPoint(path0, NULL, -width / 2., height / 2.);
    CGPathAddLineToPoint(path0, NULL, -width / 2., 0.);
    CGPathAddLineToPoint(path0, NULL, (cosf(M_PI) * outerRadius), 0.);
    CGPathAddArc(path0, NULL, 0., 0., outerRadius, M_PI, 0., 1.);
    CGPathAddLineToPoint(path0, NULL, width / 2., 0.);
    CGPathCloseSubpath(path0);
    
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGAffineTransform rotation = CGAffineTransformMakeScale(1., -1.);
    CGPathAddPath(path1, &rotation, path0);
    
    CGContextAddPath(context, path0);
    CGContextFillPath(context);
    CGPathRelease(path0);
    
    CGContextAddPath(context, path1);
    CGContextFillPath(context);
    CGPathRelease(path1);
    
    if (_progress < 1.) {
        CGFloat angle = 360. - (360. * _progress);
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2);
        CGMutablePathRef path2 = CGPathCreateMutable();
        CGPathMoveToPoint(path2, &transform, innerRadius, 0.);
        CGPathAddArc(path2, &transform, 0., 0., innerRadius, 0., angle / 180. * M_PI, 0.);
        CGPathAddLineToPoint(path2, &transform, 0., 0.);
        CGPathAddLineToPoint(path2, &transform, innerRadius, 0.);
        CGContextAddPath(context, path2);
        CGContextFillPath(context);
        CGPathRelease(path2);
    }
}

- (void)setInnerRadiusRatio:(CGFloat)innerRadiusRatio
{
    _innerRadiusRatio = (innerRadiusRatio < 0.) ? 0. : (innerRadiusRatio > 1.) ? 1. : innerRadiusRatio;
}

- (void)setOuterRadiusRatio:(CGFloat)outerRadiusRatio
{
    _outerRadiusRatio = (outerRadiusRatio < 0.) ? 0. : (outerRadiusRatio > 1.) ? 1. : outerRadiusRatio;
}

- (void)setProgress:(CGFloat)progress
{
    if (_progress != progress) {
        _progress = (progress < 0.) ? 0. : (progress > 1.) ? 1. : progress;
        if (progress > 0. && progress < 1.) {
            self.state = DAProgressOverlayViewStateOperationInProgress;
            [self setNeedsDisplay];
        } else if (progress == 1. && self.triggersDownloadDidFinishAnimationAutomatically) {
            [self displayOperationDidFinishAnimation];
        }        
    }
}

#pragma mark - Private

- (CGFloat)innerRadius
{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat radius = MIN(width, height) / 2. * self.innerRadiusRatio;
    switch (self.state) {
        case DAProgressOverlayViewStateWaiting: return radius * self.animationProggress;
        case DAProgressOverlayViewStateOperationFinished: return radius + (MAX(width, height) / sqrtf(2.) - radius) * self.animationProggress;
        default: return radius;
    }
}

- (CGFloat)outerRadius
{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat radius = MIN(width, height) / 2. * self.outerRadiusRatio;
    switch (self.state) {
        case DAProgressOverlayViewStateWaiting: return radius * self.animationProggress;
        case DAProgressOverlayViewStateOperationFinished: return radius + (MAX(width, height) / sqrtf(2.) - radius) * self.animationProggress;
        default: return radius;
    }
}

- (void)update
{
    CGFloat animationProggress = self.animationProggress + DAUpdateUIFrequency / self.stateChangeAnimationDuration;
    if (animationProggress >= 1.) {
        self.animationProggress = 1.;
        [self.timer invalidate];
    } else {
        self.animationProggress = animationProggress;
    }
    [self setNeedsDisplay];
}

@end