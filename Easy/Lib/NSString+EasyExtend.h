//
//  NSString+EasyExtend.h
//  fastSign
//
//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString (EasyExtend)
//#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
//- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;
//- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height;
//#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
- (NSString *)MD5;
- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset;
- (NSString *)trim;
- (NSArray *)words;
- (NSString *)urldecode;
- (NSString *)urlencode;

@end

@interface NSMutableString (EasyExtend)

typedef NSMutableString *	(^NSMutableStringAppendBlock)( id format, ... );
@property(nonatomic,readonly) NSMutableStringAppendBlock APPEND;

@end