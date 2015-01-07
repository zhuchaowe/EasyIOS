#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

typedef void (^EZVoidBlock)(void);
@interface EasyKit : NSObject {}

+ (NSString *)homePath;//应用程序目录的路径，在该目录下有三个文件夹：Documents、Library、temp以及一个.app包！该目录下就是应用程序的沙盒，应用程序只能访问该目录下的文件夹！！！
+ (NSString *)desktopPath;//数据所存桌面的绝对路径
+ (NSString *)documentPath;// 文档目录，需要ITUNES同步备份的数据存这里
+ (NSString *)libPrePath; // 配置目录，配置文件存这里
+ (NSString *)libCachePath; // 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)appPath;  // .app 程序相对目录，不能存任何东西
+ (NSString *)tmpPath;	// 缓存目录，APP退出后，系统可能会删除这里的内容
+ (NSString *)resourcePath; // .app 程序绝对目录，不能存任何东西
+ (BOOL)touchPath:(NSString *)path;
+ (BOOL)touchFile:(NSString *)file;

+ (BOOL)swizzleMethod:(SEL)originalSelector with:(SEL)anotherSelector in:(Class)klass;
+ (BOOL)swizzleMethod:(SEL)originalSelector in:(Class)klass with:(SEL)anotherSelector in:(Class)anotherKlass;
+ (BOOL)swizzleClassMethod:(SEL)originalSelector with:(SEL)anotherSelector in:(Class)klass;
+ (BOOL)swizzleClassMethod:(SEL)originalSelector in:(Class)klass with:(SEL)anotherSelector in:(Class)anotherKlass;

+ (void)waitUntil:(BOOL (^)(void))condition;
+ (void)waitUntil:(BOOL (^)(void))condition timeOut:(NSTimeInterval)timeOut;
+ (void)waitUntil:(BOOL (^)(void))condition timeOut:(NSTimeInterval)timeOut interval:(NSTimeInterval)interval;

/**
 直接复制代码。
 [[$ rac_didNetworkChanges]
 subscribeNext:^(NSNumber *status) {
     AFNetworkReachabilityStatus networkStatus = [status intValue];
     switch (networkStatus) {
     case AFNetworkReachabilityStatusUnknown:
     case AFNetworkReachabilityStatusNotReachable:
     [[DialogUtil sharedInstance] showDlg:self.window textOnly:@"网络连接不给力"];
     break;
     case AFNetworkReachabilityStatusReachableViaWWAN:
     [[DialogUtil sharedInstance] showDlg:self.window textOnly:@"正在使用移动数据网络"];
     break;
     case AFNetworkReachabilityStatusReachableViaWiFi:
     break;
     }
 }];
 */
+ (RACSignal*) rac_didNetworkChanges;
@end

@interface $ : EasyKit {}
@end