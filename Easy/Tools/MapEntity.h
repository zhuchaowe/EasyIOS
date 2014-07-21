//
//  MapEntity.h
//  leway
//
//  Created by 朱潮 on 14-7-2.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "Easy.h"
typedef enum
{
    transit         =0,
    driving         =1,
    walking         =2
} TransportMode;

@interface MapEntity : NSObject
@property(nonatomic,retain)NSString *sourceApplication;//应用名称。
@property(nonatomic,retain)NSString *backScheme;//第三方调回使用的 scheme,
@property(nonatomic,assign)CLLocationCoordinate2D origin;
@property(nonatomic,assign)CLLocationCoordinate2D destination;
@property(nonatomic,retain)NSString *originName;
@property(nonatomic,retain)NSString *destinationName;
@property(nonatomic,retain)NSString *destinationSubTitle;

+(NSArray *)checkHasOwnApp;
-(NSString *)callBaiduMapForPath:(TransportMode)mode native:(BOOL)callNative; //百度地图uri
-(NSString *)callAMapForPath:(TransportMode)mode native:(BOOL)callNative; //高德地图uri
-(NSString *)callGoogleMapForPath:(TransportMode)mode native:(BOOL)callNative;//google 地图uri
-(NSString *)callAppleMapForPath:(TransportMode)mode native:(BOOL)callNative;//苹果 地图uri

@end
