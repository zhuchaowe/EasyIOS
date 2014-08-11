//
//  SysTool.h
//  leway
//
//  Created by 朱潮 on 14-7-1.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Easy.h"
@interface SysTool : NSObject
+ (SysTool *)sharedInstance;
///////////////////////
//发送邮件
+ (void)sendMail:(NSString *)mail;
//打电话
+ (void)makePhoneCall:(NSString *)tel;
//发短信
+ (void)sendSMS:(NSString *)tel;
//打开URL
+ (void)openURLWithSafari:(NSString *)url;
//计算字符个数
+ (int)countWords:(NSString *)s;
//屏幕截图，并保存到相册
+ (void)saveImageFromToPhotosAlbum:(UIView *)view;
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

//获取文件夹大小
+ (NSString *)getFolderSize:(long long)size;
+ (long long)folderSizeAtPath:(NSString *)folderPath;
+ (void)deleteAll:(NSString *)cachePath;

//sha256加密
+(NSString *)getSha256String:( NSString *)srcString;
@end
