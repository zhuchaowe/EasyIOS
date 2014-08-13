//
//  SysTool.m
//  leway
//
//  Created by 朱潮 on 14-7-1.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SysTool.h"
#include <sys/stat.h>
#include <dirent.h>
#include <sys/socket.h>
#include <sys/sysctl.h>

@implementation SysTool
+ (SysTool *)sharedInstance
{
    static dispatch_once_t pred;
    static SysTool *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (void)sendMail:(NSString *)mail {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mail]];
}

+ (void)makePhoneCall:(NSString *)tel {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}

+ (void)sendSMS:(NSString *)tel {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}

+ (void)openURLWithSafari:(NSString *)url {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
+ (int)countWords:(NSString *)s {
	int i, n = (int)[s length], l = 0, a = 0, b = 0;
	unichar c;
	for (i = 0; i < n; i++) {
		c = [s characterAtIndex:i];
		if (isblank(c)) {
			b++;
		}
		else if (isascii(c)) {
			a++;
		}
		else {
			l++;
		}
	}
	if (a == 0 && l == 0) {
		return 0;
	}
	return l + (int)ceilf((float)(a + b) / 2.0);
}

+ (UIImage *)saveImageFromView:(UIView *)view {
	UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.layer.contentsScale);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

+ (void)savePhotosAlbum:(UIImage *)image {
	UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

+ (void)saveImageFromToPhotosAlbum:(UIView *)view {
	UIImage *image = [self saveImageFromView:view];
	[self savePhotosAlbum:image];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	NSString *message;
	NSString *title;
	if (!error) {
		title = @"成功提示";
		message = @"成功保存到相";
	}
	else {
		title = @"失败提示";
		message = [error description];
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
	                                                message:message
	                                               delegate:nil
	                                      cancelButtonTitle:@"知道了"
	                                      otherButtonTitles:nil];
	[alert show];
}


+ (NSString *)getFolderSize:(long long)size {
	if (size < 1000) {
		return [NSString stringWithFormat:@"%lldB", size];
	}
	else if (size < 1000 * 1000) {
		return [NSString stringWithFormat:@"%.2fKB", size * 1.0 / 1000];
	}
	else if (size < 1000 * 1000 * 1000) {
		return [NSString stringWithFormat:@"%.2fMB", size * 1.0 / 1000 / 1000];
	}
	else if (size < 1000.0 * 1000.0 * 1000.0 * 1000.0) {
		return [NSString stringWithFormat:@"%.2fGB", size * 1.0 / 1000 / 1000 / 1000];
	}
	return @"";
}

+ (long long)folderSizeAtPath:(NSString *)folderPath {
	return [self _folderSizeAtPath:[folderPath cStringUsingEncoding:NSUTF8StringEncoding]];
}

+ (long long)_folderSizeAtPath:(const char *)folderPath {
	long long folderSize = 0;
	DIR *dir = opendir(folderPath);
	if (dir == NULL) return 0;
	struct dirent *child;
	while ((child = readdir(dir)) != NULL) {
		if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) ||                         // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0)                         // 忽略目录 ..
                                        )) continue;
        
		NSUInteger folderPathLength = strlen(folderPath);
		char childPath[1024]; // 子文件的路径地址
		stpcpy(childPath, folderPath);
		if (folderPath[folderPathLength - 1] != '/') {
			childPath[folderPathLength] = '/';
			folderPathLength++;
		}
		stpcpy(childPath + folderPathLength, child->d_name);
		childPath[folderPathLength + child->d_namlen] = 0;
		if (child->d_type == DT_DIR) { // directory
			folderSize += [self _folderSizeAtPath:childPath]; // 递归调用子目录
			// 把目录本身所占的空间也加上
			struct stat st;
			if (lstat(childPath, &st) == 0) folderSize += st.st_size;
		}
		else if (child->d_type == DT_REG || child->d_type == DT_LNK) { // file or link
			struct stat st;
			if (lstat(childPath, &st) == 0) folderSize += st.st_size;
		}
	}
	return folderSize;
}

+ (void)deleteAll:(NSString *)cachePath {
	[[NSFileManager defaultManager] removeItemAtPath:cachePath error:NULL];
	[[NSFileManager defaultManager] createDirectoryAtPath:cachePath
	                          withIntermediateDirectories:YES
	                                           attributes:nil
	                                                error:NULL];
}


+(NSString *)getSha256String:(NSString *)srcString {
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}
@end
