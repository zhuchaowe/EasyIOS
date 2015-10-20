//
//  UIViewController+URLManage.m
//  rssreader
//
//  Created by zhuchao on 15/2/11.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "UIViewController+URLManage.h"
#import <objc/runtime.h>

static char URLoriginUrl;
static char URLpath;
static char URLparams;
static char URLdictQuery;

@implementation UIViewController (URLManage)
-(void)setOriginUrl:(NSURL *)originUrl{
    [self willChangeValueForKey:@"originUrl"];
    objc_setAssociatedObject(self, &URLoriginUrl,
                             originUrl,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"originUrl"];
}
-(NSURL *)originUrl {
    return objc_getAssociatedObject(self, &URLoriginUrl);
}

-(NSString *)path {
    return objc_getAssociatedObject(self, &URLpath);
}
-(void)setPath:(NSURL *)path{
    [self willChangeValueForKey:@"path"];
    objc_setAssociatedObject(self, &URLpath,
                             path,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"path"];
}


-(NSDictionary *)params {
    return objc_getAssociatedObject(self, &URLparams);
}
-(void)setParams:(NSDictionary *)params{
    [self willChangeValueForKey:@"params"];
    objc_setAssociatedObject(self, &URLparams,
                             params,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"params"];
}

-(NSDictionary *)dictQuery {
    return objc_getAssociatedObject(self, &URLdictQuery);
}

-(void)setDictQuery:(NSDictionary *)dictQuery{
    [self willChangeValueForKey:@"dictQuery"];
    objc_setAssociatedObject(self, &URLdictQuery,
                             dictQuery,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"dictQuery"];
}


-(void)open:(NSURL *)url withQuery:(NSDictionary *)dict{
    self.path = [url path];
    self.params = [url params];
    self.originUrl = url;
    self.dictQuery = dict;
}

+ (UIViewController *)initFromString:(NSString *)aString fromConfig:(NSDictionary *)config{
    return [UIViewController initFromURL:[NSURL URLWithString:aString] withQuery:nil fromConfig:config];
}

+ (UIViewController *)initFromURL:(NSURL *)url fromConfig:(NSDictionary *)config{
    return [UIViewController initFromURL:url withQuery:nil fromConfig:config];
}

+ (UIViewController *)initFromString:(NSString *)aString withQuery:(NSDictionary *)query fromConfig:(NSDictionary *)config{
    return [UIViewController initFromURL:[NSURL URLWithString:aString] withQuery:query fromConfig:config] ;
}

+ (UIViewController *)initFromURL:(NSURL *)url withQuery:(NSDictionary *)query fromConfig:(NSDictionary *)config
{
    UIViewController* scene = nil;
    NSString *home;
    if(url.path ==nil){
        home = [NSString stringWithFormat:@"%@://%@", url.scheme, url.host];
    }else{
        home = [NSString stringWithFormat:@"%@://%@%@", url.scheme, url.host,url.path];
    }
    if([config.allKeys containsObject:url.scheme]){
        id cgf = [config objectForKey:url.scheme];
        Class class = nil;
        if([cgf isKindOfClass:[NSString class]]){
            class =  NSClassFromString(cgf);
        }else if([cgf isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary *)cgf;
            if([dict.allKeys containsObject:home]){
                class =  NSClassFromString([dict objectForKey:home]);
            }else{
                class =  NSClassFromString(url.host);
            }
        }
        if(class !=nil){
            if([NSStringFromClass(class) isEqualToString:@"TOWebViewController"]){
                scene = [[class alloc]initWithURL:url];
                if([scene  respondsToSelector:@selector(open:withQuery:)]){
                    [scene open:url withQuery:query];
                }
            }else{
                scene = [[class alloc]init];
                if([scene  respondsToSelector:@selector(open:withQuery:)]){
                    [scene open:url withQuery:query];
                }
            }
        }
    }else if([query objectForKey:@"openURL"]){
        [[UIApplication sharedApplication] openURL:url];
    }
    return scene;
}

@end
