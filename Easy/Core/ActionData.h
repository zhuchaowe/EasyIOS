//
//  ActionData.h
//  fastSign
//
//  Created by EasyIOS on 14-4-11.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"
typedef enum
{
    SuccessState                    =0,
    FailState                       =1,
    SendingState                    =2,
    ErrorState                      =3
} ActionState;

@interface ActionData : NSObject
@property(nonatomic,strong)NSString *key;
@property(nonatomic,strong)NSDictionary * output;
@property(nonatomic,strong)NSString *responseString;
@property(nonatomic,strong)NSError *error;
@property(nonatomic,assign)NSInteger state;
@property(nonatomic,strong)NSString *path;
@property(nonatomic,strong)NSString *method;
@property(nonatomic,strong)NSString *discription;
@property(nonatomic,strong)NSDictionary *params;
@property(nonatomic,strong)NSDictionary *files;
@property(nonatomic,assign)double progress;
@property(nonatomic,strong)MKNetworkOperation *op;

+(id)Data;
- (BOOL)validate:(NSString *)key;
- (BOOL)succeed;
- (BOOL)sending;
- (BOOL)failed;

@end
