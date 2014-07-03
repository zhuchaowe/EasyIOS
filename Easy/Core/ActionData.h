//
//  ActionData.h
//  fastSign
//
//  Created by EasyIOS on 14-4-11.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MSG_FOR_KEY(_msg,_key) [_msg.key isEqualToString:_key]
typedef enum
{
    SuccessState                    =0,
    FailState                       =1,
    SendingState                    =2,
    ErrorState                      =3
} ActionState;

@interface ActionData : NSObject
@property(nonatomic,strong)NSString *key;
@property(nonatomic,strong)id output;
@property(nonatomic,strong)NSError *error;
@property(nonatomic,assign)NSInteger state;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *path;
@property(nonatomic,strong)NSString *method;
@property(nonatomic,strong)NSString *discription;
@property(nonatomic,strong)NSDictionary *params;

+(id)Data;

- (BOOL)succeed;
- (BOOL)sending;
- (BOOL)failed;

@end
