//
//  UIGestureRecognizer+SHGestureRecognizerBlocks.h
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//


#pragma mark - Block Defs
typedef void (^SHGestureRecognizerBlock)(UIGestureRecognizer * sender, UIGestureRecognizerState state, CGPoint location);

@interface UIGestureRecognizer (SHGestureRecognizerBlocks)

#pragma mark - Init
+(instancetype)SH_gestureRecognizerWithBlock:(SHGestureRecognizerBlock)theBlock;

#pragma mark - Add block
-(void)SH_addBlock:(SHGestureRecognizerBlock)theBlock;

#pragma mark - Remove block
-(void)SH_removeBlock:(SHGestureRecognizerBlock)theBlock;
-(void)SH_removeAllBlocks;

#pragma mark - Properties

#pragma mark - Getters
@property(nonatomic,readonly) NSSet * SH_blocks;

@end
