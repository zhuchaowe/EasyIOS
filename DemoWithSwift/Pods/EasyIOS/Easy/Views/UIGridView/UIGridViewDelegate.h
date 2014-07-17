//
//  UIGridViewDelegate.h
//  foodling2
//
//  Created by Tanin Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
@protocol UIGridViewDelegate
@optional
- (void) gridView:(UIGridView *)grid didSelectRowAt:(NSInteger)rowIndex AndColumnAt:(NSInteger)columnIndex;
@required
- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(NSInteger)columnIndex;
- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(NSInteger)rowIndex;

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid;
- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid;

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(NSInteger)rowIndex AndColumnAt:(NSInteger)columnIndex;

@end