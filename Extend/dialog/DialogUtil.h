//
//  ;
//  wq
//
//  Created by berwin on 13-6-28.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+MBHud.h"


@interface DialogUtil : NSObject<MBProgressHUDDelegate> {
	long long expectedLength;
	long long currentLength;
}

+ (DialogUtil *)sharedInstance;

+ (void)showDlgAlert:(NSString *) label;
+ (void)showDlgAlert:(NSString *) label cancelButtonTitle:(NSString *)str title:(NSString *)tips;
- (void)showDlgCommon:(UIView *) view;
- (void)showDlg:(UIView *) view withLabel:(NSString *) label;
- (void)showDlg:(UIView *) view withLabel:(NSString *)label withDetail:(NSString *)detail;
- (void)showDlg:(UIView *) view withLabelDeterminate:(NSString *) label;
- (void)showDlg:(UIView *)view withLabelAnnularDeterminate:(NSString *) label;
- (void)showDlgWithLabelDeterminateHorizontalBar:(UIView *) view;
- (void)showDlg:(UIView *) view withImage:(NSString *) imgName withLabel:(NSString *) label;
- (void)showDldLabelMixed:(UIView *) view;
- (void)showDlg:(UIView *) view usingBlocks:(NSString *)label;
- (void)showDlg:(UIView *) view onWindow:(NSString *) label;
- (void)showDlg:(UIView *) view witgURL:(NSString *) url;
- (void)showDlgWithGradient:(UIView *) view;
- (void)showDlg:(UIView *) view textOnly:(NSString *) label;
- (void)showDlg:(UIView *) view withColor:(UIColor *) color;
@end
