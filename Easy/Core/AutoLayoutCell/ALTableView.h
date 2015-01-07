//
//  ALTableView.h
//  AutoLayoutCells
//
//  Created by Joshua Greene on 9/5/14.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import <UIKit/UIKit.h>
#import "ALTableViewCellFactory.h"
#import "SceneTableView.h"
/**
 *  `ALTableView` will automatically call `reloadData` on itself in the event that it receives a `UIContentSizeCategoryDidChangeNotification` notification.
 */
@interface ALTableView :SceneTableView
@property (strong, nonatomic) ALTableViewCellFactory *cellFactory;

@end

@interface ALTableView (Protected)

///--------------------------------------------------------------
/// @name Protected Methods
///--------------------------------------------------------------

/**
 *  Subclasses should use this method for common setup (`init`) code.
 *
 * @discussion The default implementation registers for `UIContentSizeCategoryDidChangeNotification` notifications. This method is called by all `init` methods after `self` has already been initialized.
 */
- (void)commonInit __attribute((objc_requires_super));

/**
 *  This method is called whenever the`UIContentSizeCategoryDidChangeNotification` notification is received.
 *
 *  @discussion This method calls `reloadData` on itself, within a `dispatch_async` block on the main thread.
 *
 *  The reason `dispatch_async` is used is to allow AL cells the chance to update themselves first.
 *
 *  @param notification The `UIContentSizeCategoryDidChangeNotification` notification object.
 */
- (void)contentSizeCategoryDidChange:(NSNotification *)notification __attribute((objc_requires_super));

@end