//
//  UIGestureRecognizer+SHGestureRecognizerBlocks.h
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "UIGestureRecognizer+SHGestureRecognizerBlocks.h"



@interface SHGestureRecognizerBlocksManager : NSObject
@property(nonatomic,strong) NSMapTable     * mapBlocks;

+(instancetype)sharedManager;

-(void)SH_memoryDebugger;
@end

@implementation SHGestureRecognizerBlocksManager

#pragma mark - Init & Dealloc
-(instancetype)init; {
  self = [super init];
  if (self) {
    self.mapBlocks            = [NSMapTable weakToStrongObjectsMapTable];
//    [self SH_memoryDebugger];
  }
  
  return self;
}


+(instancetype)sharedManager; {
  static SHGestureRecognizerBlocksManager *_sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[SHGestureRecognizerBlocksManager alloc] init];
    
  });
  
  return _sharedInstance;
  
}


#pragma mark - Debugger
-(void)SH_memoryDebugger; {
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    NSLog(@"MAP %@",self.mapBlocks);

    [self SH_memoryDebugger];
  });
}


@end

@interface UIGestureRecognizer ()
@property(nonatomic,strong) NSMutableSet * mutableBlocks;
@end

@interface UIGestureRecognizer (SHGestureRecognizerBlocksPrivates)

-(void)performBlockAction:(UIGestureRecognizer *)theGestureRecognizer;
-(instancetype)initWithBlock:(SHGestureRecognizerBlock)theBlock;
@end



@implementation UIGestureRecognizer (SHGestureRecognizerBlocks)


#pragma mark - Init


+(instancetype)SH_gestureRecognizerWithBlock:(SHGestureRecognizerBlock)theBlock; {
  return [[[self class] alloc] initWithBlock:theBlock];
}


#pragma mark - Add block
-(void)SH_addBlock:(SHGestureRecognizerBlock)theBlock; {
  if(theBlock) [self.mutableBlocks addObject:[theBlock copy]];
}


#pragma mark - Remove block
-(void)SH_removeBlock:(SHGestureRecognizerBlock)theBlock; {
  [self.mutableBlocks removeObject:theBlock];
  if(self.mutableBlocks.count < 1)
    [self SH_removeAllBlocks];
}

-(void)SH_removeAllBlocks; {
  [self.view removeGestureRecognizer:self];
  [self removeTarget:nil action:nil];
  self.mutableBlocks = nil;
}



#pragma mark - Properties


#pragma mark Getters
-(NSSet *)SH_blocks; {
  return self.mutableBlocks.copy;
}


#pragma mark - Privates


#pragma mark - Init

-(instancetype)initWithBlock:(SHGestureRecognizerBlock)theBlock; {
  self = [self initWithTarget:self action:@selector(performBlockAction:)];
	if (self) {
    [self SH_addBlock:theBlock];
	}
	return self;
  
}


#pragma mark - Properties


#pragma mark - Getters
-(NSMutableSet *)mutableBlocks; {
  NSMutableSet * blocks = [SHGestureRecognizerBlocksManager.sharedManager.mapBlocks
   objectForKey:self];
  if(blocks == nil) {
    blocks = [NSMutableSet set];
    self.mutableBlocks = blocks;
  }
  return blocks;
}

#pragma mark - Setters
-(void)setMutableBlocks:(NSMutableSet *)theSet; {
  if(theSet == nil) {
    [self removeTarget:nil action:nil];
    [SHGestureRecognizerBlocksManager.sharedManager.mapBlocks
     removeObjectForKey:self];
  }
  else
    [SHGestureRecognizerBlocksManager.sharedManager.mapBlocks
     setObject:theSet forKey:self];
    
}


#pragma mark - Actions
-(void)performBlockAction:(UIGestureRecognizer *)theGestureRecognizer {
  id<NSFastEnumeration> blocks = self.SH_blocks;

  CGPoint location = [self locationInView:self.view];
  for (SHGestureRecognizerBlock block in blocks) {
    block(self,self.state,location);
  }
}




@end

