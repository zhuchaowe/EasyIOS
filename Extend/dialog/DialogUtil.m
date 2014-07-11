//
//  DialogUtil.m
//  wq
//
//  Created by berwin on 13-6-28.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "DialogUtil.h"

@implementation DialogUtil

+ (DialogUtil *) sharedInstance
{
    static DialogUtil *sharedInstance = nil ;
    static dispatch_once_t onceToken;  // 锁
    dispatch_once (&onceToken, ^ {     // 最多调用一次
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

// 当第一次使用这个单例时，会调用这个init方法。
- (id)init
{
    self = [super init];
    
    if (self) {
        // 通常在这里做一些相关的初始化任务
    }
    
    return self;
}

+ (void)showDlgAlert:(NSString *) label {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:label delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView setBackgroundColor:[UIColor clearColor]];
    
    //必须在这里调用show方法，否则indicator不在UIAlerView里面
    [alertView show];
}

+ (void)showDlgAlert:(NSString *) label cancelButtonTitle:(NSString *)str title:(NSString *)tips {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:tips message:label delegate:self  cancelButtonTitle:str otherButtonTitles:nil, nil];
    [alertView setBackgroundColor:[UIColor clearColor]];
    
    //必须在这里调用show方法，否则indicator不在UIAlerView里面
    [alertView show];
}


- (void)showDlgCommon:(UIView *) view {
	// The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	hud.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (void)showDlg:(UIView *) view withLabel:(NSString *) label {
	
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	hud.delegate = self;
	hud.labelText = label;
	[hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (void)showDlg:(UIView *) view withLabel:(NSString *)label withDetail:(NSString *)detail {
	
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
    hud.delegate = self;
	hud.labelText = label;
	hud.detailsLabelText = detail;
	hud.square = YES;
    [hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (void)showDlg:(UIView *) view withLabelDeterminate:(NSString *) label{
	
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	
	// Set determinate mode
	hud.mode = MBProgressHUDModeDeterminate;
	
	hud.delegate = self;
	hud.labelText = label;
	
	// myProgressTask uses the HUD instance to update progress
	[hud showWhileExecuting:@selector(myProgressTask:) onTarget:self withObject:hud animated:YES];
}

- (void)showDlg:(UIView *)view withLabelAnnularDeterminate:(NSString *) label {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	
	// Set determinate mode
	hud.mode = MBProgressHUDModeAnnularDeterminate;
	
	hud.delegate = self;
	hud.labelText = label;
	
	// myProgressTask uses the HUD instance to update progress
	[hud showWhileExecuting:@selector(myProgressTask:) onTarget:self withObject:hud animated:YES];
}

- (void)showDlgWithLabelDeterminateHorizontalBar:(UIView *) view  {
	
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	
	// Set determinate bar mode
	hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
	
	hud.delegate = self;
	
	// myProgressTask uses the HUD instance to update progress
	[hud showWhileExecuting:@selector(myProgressTask:) onTarget:self withObject:hud animated:YES];
}

- (void)showDlg:(UIView *) view withImage:(NSString *) imgName withLabel:(NSString *) label {
	
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	
	// The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
	
    //@"37x-Checkmark.png"
    
	// Set custom view mode
	hud.mode = MBProgressHUDModeCustomView;
	
	hud.delegate = self;
	hud.labelText = label;
	
	[hud show:YES];
	[hud hide:YES afterDelay:2];
}

- (void)showDldLabelMixed:(UIView *) view {
	
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	
	hud.delegate = self;
	hud.labelText = @"Connecting";
	hud.minSize = CGSizeMake(135.f, 135.f);
	
	[hud showWhileExecuting:@selector(myMixedTask:) onTarget:self withObject:hud animated:YES];
}

- (void)showDlg:(UIView *) view usingBlocks:(NSString *)label {
#if NS_BLOCKS_AVAILABLE
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	hud.labelText = label;
	
	[hud showAnimated:YES whileExecutingBlock:^{
		[self myTask];
	} completionBlock:^{
		[hud removeFromSuperview];
	}];
#endif
}

- (void)showDlg:(UIView *) view onWindow:(NSString *) label {
	// The hud will dispable all input on the window
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view.window];
	[view.window addSubview:hud];
	
	hud.delegate = self;
	hud.labelText = label;
	
	[hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (void)showDlg:(UIView *) view witgURL:(NSString *) url {
    //@"https://github.com/matej/MBProgressHUD/zipball/master"
	NSURL *URL = [NSURL URLWithString:url];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connection start];
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.delegate = self;
}


- (void)showDlgWithGradient:(UIView *) view {
	
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	
	hud.dimBackground = YES;
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	hud.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (void)showDlg:(UIView *) view textOnly:(NSString *) label {
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = label;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:1];
}

- (void)showDlg:(UIView *) view withColor:(UIColor *) color {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	
	// Set the hud to display with a color
    //[UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90]
	hud.color = color;
	
	hud.delegate = self;
	[hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}


#pragma mark -
#pragma mark Execution code

- (void)myTask {
	// Do something usefull in here instead of sleeping ...
	sleep(1);
}

- (void)myProgressTask:(MBProgressHUD *) hud {
	// This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		hud.progress = progress;
		usleep(50000);
	}
}

- (void)myMixedTask:(MBProgressHUD *) hud {
	// Indeterminate mode
	sleep(2);
	// Switch to determinate mode
	hud.mode = MBProgressHUDModeDeterminate;
	hud.labelText = @"Progress";
	float progress = 0.0f;
	while (progress < 1.0f)
	{
		progress += 0.01f;
		hud.progress = progress;
		usleep(50000);
	}
	// Back to indeterminate mode
	hud.mode = MBProgressHUDModeIndeterminate;
	hud.labelText = @"Cleaning up";
	sleep(2);
	// The sample image is based on the work by www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	hud.mode = MBProgressHUDModeCustomView;
	hud.labelText = @"Completed";
	sleep(2);
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	hud = nil;
}


@end
