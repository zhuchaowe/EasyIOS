//
//  MapEntity.m
//  leway
//
//  Created by 朱潮 on 14-7-2.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "MapEntity.h"
#import <MapKit/MapKit.h>

const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
//火星转百度坐标
void bd_encrypt(double gg_lat, double gg_lon, double *bd_lat, double *bd_lon)
{
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    *bd_lon = z * cos(theta) + 0.0065;
    *bd_lat = z * sin(theta) + 0.006;
}
//百度坐标转火星
void bd_decrypt(double bd_lat, double bd_lon, double *gg_lat, double *gg_lon)
{
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    *gg_lon = z * cos(theta);
    *gg_lat = z * sin(theta);
}

@implementation MapEntity

+(NSArray *)checkHasOwnApp{
    NSArray *mapSchemeArr = @[@"comgooglemaps://",@"iosamap://",@"baidumap://"];
    
    NSMutableArray *appListArr = [[NSMutableArray alloc] initWithObjects:@"苹果地图", nil];
    
    for (int i = 0; i < [mapSchemeArr count]; i++) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[mapSchemeArr objectAtIndex:i]]]]) {
            if (i == 0) {
                [appListArr addObject:@"google地图"];
            }else if (i == 1){
                [appListArr addObject:@"高德地图"];
            }else if (i == 2){
                [appListArr addObject:@"百度地图"];
            }
        }
    }
    [appListArr addObject:@"显示路线"];
    
    return appListArr;
}
//百度地图uri
-(NSString *)callBaiduMapForPath:(TransportMode)mode native:(BOOL)callNative{
    NSString *transModel = @"";
    if (mode == transit) {
        transModel = @"transit";
    }else if (mode == driving) {
        transModel = @"driving";
    }else if (mode == walking) {
        transModel = @"walking";
    }else{
        return nil;
    }
    if(callNative && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        NSString *baseUrl = @"baidumap://map/direction";
        NSDictionary *dict = @{@"origin":[NSString stringWithFormat:@"%.8f,%.8f",self.origin.latitude,self.origin.longitude],
                               @"destination":[NSString stringWithFormat:@"%.8f,%.8f",self.destination.latitude,self.destination.longitude],
                               @"mode":transModel,
                               @"coord_type":@"wgs84",
                               @"src":[self.sourceApplication stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
        NSString *url = [baseUrl urlByAppendingDict:dict encoding:NO];
        return url;
    }else{
        return nil;
    }
}

 //高德地图uri
-(NSString *)callAMapForPath:(TransportMode)mode native:(BOOL)callNative{
    NSString *transModel = @"";
    if (mode == transit) {
        transModel = @"1";
    }else if (mode == driving) {
        transModel = @"0";
    }else if (mode == walking) {
        transModel = @"4";
    }else{
        return nil;
    }
    if(callNative && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        NSString *baseUrl = @"iosamap://path";
        NSDictionary *dict = @{@"sourceApplication":[self.sourceApplication stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               @"backScheme":self.backScheme,
                               @"sid":@"BGVIS1",
                               @"did":@"BGVIS2",
                               @"slat":[NSString stringWithFormat:@"%.8f",self.origin.latitude],
                               @"slon":[NSString stringWithFormat:@"%.8f",self.origin.longitude],
                               @"dlat":[NSString stringWithFormat:@"%.8f",self.destination.latitude],
                               @"dlon":[NSString stringWithFormat:@"%.8f",self.destination.longitude],
                               @"sname":[self.originName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               @"dname":[self.destinationName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               @"dev":@"0",
                               @"m":@"1",
                               @"t":transModel};
        NSString *url = [baseUrl urlByAppendingDict:dict encoding:NO];
        return url;
    }else{
        NSString *baseUrl = @"http://mo.amap.com/";
        NSDictionary *dict = @{@"from":[NSString stringWithFormat:@"%.8f,%.8f",self.origin.latitude,self.origin.longitude],
                               @"to":[NSString stringWithFormat:@"%.8f,%.8f",self.destination.latitude,self.destination.longitude],
                               @"dev":@"0",
                               @"opt":@"1",
                               @"type":transModel};
        NSString *url = [baseUrl urlByAppendingDict:dict encoding:NO];
        return url;
    }
}

//google 地图uri
-(NSString *)callGoogleMapForPath:(TransportMode)mode native:(BOOL)callNative{
    NSString *transModel = @"";
    if (mode == transit) {
        transModel = @"transit";
    }else if (mode == driving) {
        transModel = @"driving";
    }else if (mode == walking) {
        transModel = @"walking";
    }else{
        return nil;
    }
    if(callNative){
        NSString *baseUrl = @"comgooglemaps://";
        NSDictionary *dict = @{@"saddr":[NSString stringWithFormat:@"%.8f,%.8f",self.origin.latitude,self.origin.longitude],
                               @"daddr":[NSString stringWithFormat:@"%.8f,%.8f",self.destination.latitude,self.destination.longitude],
                               @"sort":@"def",
                               @"directionsmode":transModel};
        NSString *url = [baseUrl urlByAppendingDict:dict encoding:NO];
        return url;
    }else{
        return nil;
    }
}

//苹果 地图uri
-(NSString *)callAppleMapForPath:(TransportMode)mode native:(BOOL)callNative{
    if (IOS5_OR_EARLIER || !callNative) {//ios5 调用高德网页地图
        return [self callAMapForPath:mode native:callNative];
    }else{//ios6 ios7 跳转apple map
        NSString *transModel = @"";
        if (mode == driving) {
            transModel = MKLaunchOptionsDirectionsModeDriving;
        }else if (mode == walking) {
            transModel = MKLaunchOptionsDirectionsModeWalking;
        }else if (mode == transit) {
            transModel = MKLaunchOptionsDirectionsModeDriving;
        }else {
            return nil;
        }
        
        CLLocationCoordinate2D to;
        to.latitude = self.destination.latitude;
        to.longitude = self.destination.longitude;
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
        toLocation.name = self.destinationName;
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:transModel, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
        return nil;
    }
}

@end
