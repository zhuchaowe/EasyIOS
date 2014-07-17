//
//  PageControl.m
//  PageControlDemo
//
/**
 * Created by honcheng on 5/14/11.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject 
 * to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT 
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
 * IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author 		Muh Hon Cheng <honcheng@gmail.com> http://twitter.com/honcheng
 * @copyright	2011	Muh Hon Cheng
 * 
 */

#import "StyledPageControl.h"


@implementation StyledPageControl
@synthesize _numberOfPages, _currentPage, hidesForSinglePage;
@synthesize coreNormalColor, coreSelectedColor;
@synthesize strokeNormalColor, strokeSelectedColor;
@synthesize _pageControlStyle, _strokeWidth, diameter, gapWidth;
@synthesize thumbImage, selectedThumbImage;

#define COLOR_GRAYISHBLUE [UIColor colorWithRed:128/255.0 green:130/255.0 blue:133/255.0 alpha:1]
#define COLOR_GRAY [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        self._strokeWidth = 2;
        self.gapWidth = 10;
        self.diameter = 12;
        self._pageControlStyle = PageControlStyleDefault;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)onTapped:(UITapGestureRecognizer*)gesture
{
    CGPoint touchPoint = [gesture locationInView:[gesture view]];
    
    if (touchPoint.x < self.frame.size.width/2)
    {
        // move left
        if (self._currentPage>0)
        {
            self._currentPage -= 1;
        }
        
    }
    else
    {
        // move right
        if (self._currentPage<self._numberOfPages-1)
        {
            self._currentPage += 1;
        }
    }
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)drawRect:(CGRect)rect
{
    UIColor *_coreNormalColor, *_coreSelectedColor, *_strokeNormalColor, *_strokeSelectedColor;
    
    if (self.coreNormalColor) _coreNormalColor = self.coreNormalColor;
    else _coreNormalColor = COLOR_GRAYISHBLUE;
    
    if (self.coreSelectedColor) _coreSelectedColor = self.coreSelectedColor;
    else
    {
        if (self._pageControlStyle==PageControlStyleStrokedCircle || self._pageControlStyle==PageControlStyleWithPageNumber)
        {
            _coreSelectedColor = COLOR_GRAYISHBLUE;
        }
        else
        {
            _coreSelectedColor = COLOR_GRAY;
        }
    }
    
    if (self.strokeNormalColor) _strokeNormalColor = self.strokeNormalColor;
    else 
    {
        if (self._pageControlStyle==PageControlStyleDefault && self.coreNormalColor)
        {
            _strokeNormalColor = self.coreNormalColor;
        }
        else
        {
            _strokeNormalColor = COLOR_GRAYISHBLUE;
        }
        
    }
    
    if (self.strokeSelectedColor) _strokeSelectedColor = self.strokeSelectedColor;
    else
    {
        if (self._pageControlStyle==PageControlStyleStrokedCircle || self._pageControlStyle==PageControlStyleWithPageNumber)
        {
            _strokeSelectedColor = COLOR_GRAYISHBLUE;
        }
        else if (self._pageControlStyle==PageControlStyleDefault && self.coreSelectedColor)
        {
            _strokeSelectedColor = self.coreSelectedColor;
        }
        else
        {
            _strokeSelectedColor = COLOR_GRAY;
        }
    }
    
    // Drawing code
    if (hidesForSinglePage && self._numberOfPages==1)
	{
		return;
	}
	
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	
	int gap = self.gapWidth;
    float _diameter = self.diameter - 2*self._strokeWidth;
    
    if (self.pageControlStyle==PageControlStyleThumb)
    {
        if (self.thumbImage && self.selectedThumbImage)
        {
            _diameter = self.thumbImage.size.width;
        }
    }
	
	int total_width = self._numberOfPages*_diameter + (self._numberOfPages-1)*gap;
	
	if (total_width>self.frame.size.width)
	{
		while (total_width>self.frame.size.width)
		{
			_diameter -= 2;
			gap = _diameter + 2;
			while (total_width>self.frame.size.width) 
			{
				gap -= 1;
				total_width = self._numberOfPages*_diameter + (self._numberOfPages-1)*gap;
				
				if (gap==2)
				{
					break;
					total_width = self._numberOfPages*_diameter + (self._numberOfPages-1)*gap;
				}
			}
			
			if (_diameter==2)
			{
				break;
				total_width = self._numberOfPages*_diameter + (self._numberOfPages-1)*gap;
			}
		}
		
		
	}
	
	int i;
	for (i=0; i<self._numberOfPages; i++)
	{
		int x = (self.frame.size.width-total_width)/2 + i*(_diameter+gap);

        if (self._pageControlStyle==PageControlStyleDefault)
        {
            if (i==_currentPage)
            {
                CGContextSetFillColorWithColor(myContext, [_coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_diameter)/2,_diameter,_diameter));
                CGContextSetStrokeColorWithColor(myContext, [_strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_diameter)/2,_diameter,_diameter));
            }
            else
            {
                CGContextSetFillColorWithColor(myContext, [_coreNormalColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_diameter)/2,_diameter,_diameter));
                CGContextSetStrokeColorWithColor(myContext, [_strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_diameter)/2,_diameter,_diameter));
            }
        }
        else if (self._pageControlStyle==PageControlStyleStrokedCircle)
        {
            CGContextSetLineWidth(myContext, self._strokeWidth);
            if (i==_currentPage)
            {
                CGContextSetFillColorWithColor(myContext, [_coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_diameter)/2,_diameter,_diameter));
                CGContextSetStrokeColorWithColor(myContext, [_strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_diameter)/2,_diameter,_diameter));
            }
            else
            {
                CGContextSetStrokeColorWithColor(myContext, [_strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_diameter)/2,_diameter,_diameter));
            }
        }
        else if (self._pageControlStyle==PageControlStyleWithPageNumber)
        {
            CGContextSetLineWidth(myContext, self._strokeWidth);
            if (i==_currentPage)
            {
                int _currentPageDiameter = _diameter*1.6;
                x = (self.frame.size.width-total_width)/2 + i*(_diameter+gap) - (_currentPageDiameter-_diameter)/2;
                CGContextSetFillColorWithColor(myContext, [_coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_currentPageDiameter)/2,_currentPageDiameter,_currentPageDiameter));
                CGContextSetStrokeColorWithColor(myContext, [_strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_currentPageDiameter)/2,_currentPageDiameter,_currentPageDiameter));
            
                NSString *pageNumber = [NSString stringWithFormat:@"%i", i+1];
                CGContextSetFillColorWithColor(myContext, [[UIColor whiteColor] CGColor]);
                [pageNumber drawInRect:CGRectMake(x,(self.frame.size.height-_currentPageDiameter)/2-1,_currentPageDiameter,_currentPageDiameter) withFont:[UIFont systemFontOfSize:_currentPageDiameter-2] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
            }
            else
            {
                CGContextSetStrokeColorWithColor(myContext, [_strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_diameter)/2,_diameter,_diameter));
            }
        }
        else if (self._pageControlStyle==PageControlStylePressed1 || self._pageControlStyle==PageControlStylePressed2)
        {
            if (self._pageControlStyle==PageControlStylePressed1)
            {
                CGContextSetFillColorWithColor(myContext, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_diameter)/2-1,_diameter,_diameter));
            }
            else if (self._pageControlStyle==PageControlStylePressed2)
            {
                CGContextSetFillColorWithColor(myContext, [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_diameter)/2+1,_diameter,_diameter));
            }
            
            
            if (i==_currentPage)
            {
                CGContextSetFillColorWithColor(myContext, [_coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_diameter)/2,_diameter,_diameter));
                CGContextSetStrokeColorWithColor(myContext, [_strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_diameter)/2,_diameter,_diameter));
            }
            else
            {
                CGContextSetFillColorWithColor(myContext, [_coreNormalColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_diameter)/2,_diameter,_diameter));
                CGContextSetStrokeColorWithColor(myContext, [_strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_diameter)/2,_diameter,_diameter));
            }
        }
        else if (self.pageControlStyle==PageControlStyleThumb)
        {
            if (self.thumbImage && self.selectedThumbImage)
            {
                if (i==_currentPage)
                {
                    [self.selectedThumbImage drawInRect:CGRectMake(x,(self.frame.size.height-_diameter)/2,_diameter,_diameter)];
                }
                else
                {
                    [self.thumbImage drawInRect:CGRectMake(x,(self.frame.size.height-_diameter)/2,_diameter,_diameter)];
                }
            }
        }
	}
}

- (PageControlStyle)pageControlStyle
{
    return self._pageControlStyle;
}

- (void)setPageControlStyle:(PageControlStyle)style
{
    self._pageControlStyle = style;
    [self setNeedsDisplay];
}

- (void)setCurrentPage:(int)page
{
    self._currentPage = page;
    [self setNeedsDisplay];
}

- (int)currentPage
{
    return self._currentPage;
}

- (void)setNumberOfPages:(int)numOfPages
{
    self._numberOfPages = numOfPages;
    [self setNeedsDisplay];
}

- (int)numberOfPages
{
    return self._numberOfPages;
}


@end
