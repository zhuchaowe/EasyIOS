//
//  ALBaseCell.h
//  AutoLayoutCells
//
//  Created by Joshua Greene on 07/11/14.
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
#import "EzTableViewCell.h"
/**
 *  This is the base cell class for all table view cells within `AutoLayoutCells`.
 *
 *  @discussion You should set the cell's values via `setValuesFromDictionary` instead of each property directly.
 *  @see `ALCellConstants` for predefined dictionary value keys.
 */
@interface ALBaseCell : EzTableViewCell

///--------------------------------------------------------------
/// @name Instance Properties
///--------------------------------------------------------------

/**
 *  The delegated that should be notified of value-related events.
 *
 *  @discussion Each cell will have a `delegate` object. While `ALCellDelegate` is the most commonly required delegate protocol, it doesn't strictly have to be.
 */
@property (weak, nonatomic) IBOutlet id delegate;

/**
 *  Whether this cell should be treated as a sizing cell. The default value is `NO`.
 *
 *  @discussion Cell subclasses may treat sizing cells slightly differently than normal cells. In example, image loading from URL may be skipped.
 */
@property (assign, nonatomic) BOOL isSizingCell;


@end

@interface ALBaseCell (Protected)


/**
 *  Subclasses should use this method to "reset" the font of any dynamic type text labels, text views, etc. This method is called whenever the`UIContentSizeCategoryDidChangeNotification` notification is received.
 *
 *  @discussion The default implementation of this method is empty (but this may change in the future).
 *
 *  @param notification The `UIContentSizeCategoryDidChangeNotification` notification object.
 */
- (void)contentSizeCategoryDidChange:(NSNotification *)notification __attribute((objc_requires_super));

@end
