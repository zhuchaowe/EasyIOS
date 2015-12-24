//
//  Request.h
//  NewEasy
//
//  Created by 朱潮 on 14-7-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyKit.h"

extern NSString * const RequestStateSuccess;
extern NSString * const RequestStateFailed;
extern NSString * const RequestStateSending;
extern NSString * const RequestStateError;
extern NSString * const RequestStateCancle;

@interface Request : NSObject
@property(nonatomic,strong)NSDictionary * output;// 序列化后的数据
@property(nonatomic,strong)NSMutableDictionary* params; //使用字典参数
@property(nonatomic,strong)NSString *responseString; // 获取的字符串数据
@property(nonatomic,strong)NSError *error; //请求的错误
@property(nonatomic,assign)NSString* state; //Request状态
@property(nonatomic,strong)NSURL *url;  //请求的链接
@property(nonatomic,strong)NSString *message; //错误消息或者服务器返回的MSG
@property(nonatomic,strong)NSString *codeKey;  // 错误码返回
//upload上传相关参数
@property(nonatomic,strong)NSDictionary *requestFiles; //上传文件列表
@property(nonatomic,assign)NSProgress *progress; //上传进度
//@property(nonatomic,assign)long long totalBytesWritten; //已上传数据大小
//@property(nonatomic,assign)long long totalBytesExpectedToWrite; //全部需要上传的数据大小

// download下载相关参数
@property(nonatomic,strong)NSString *downloadUrl; //下载链接
@property(nonatomic,strong)NSString *targetPath; //下载到目标路径
//@property(nonatomic,assign)long long totalBytesRead; //已下载传数据大小
//@property(nonatomic,assign)long long totalBytesExpectedToRead; //全部需要下载的数据大小

@property(nonatomic,assign)BOOL freezable;  //是否冻结，下次联网时继续(保留设计)

@property(nonatomic,strong)NSString *SCHEME; //协议
@property(nonatomic,strong)NSString *HOST;//域名
@property(nonatomic,strong)NSString *PATH;//请求路径
@property(nonatomic,strong)NSString *STATICPATH;//其他路径
@property(nonatomic,strong)NSString *METHOD;//提交方式
@property(nonatomic,assign)BOOL needCheckCode;//是否需要检查错误码
@property(nonatomic,strong)NSSet *acceptableContentTypes; //可接受的序列化返回数据的格式
@property(nonatomic,strong)NSDictionary *httpHeaderFields;//Http头参数设置
@property(nonatomic,assign)BOOL requestNeedActive; //是否启动发送请求(为MVVM设计)
@property(nonatomic,strong)NSURLSessionTask *op; //AFN返回的NSURLSessionTask
@property(nonatomic,copy)EZVoidBlock requestInActiveBlock;//激活请求后的Block
/**
 * 设置请求超时时间，默认是60S。
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property(nonatomic,assign)BOOL isTimeout;//请求是否超时

@property(nonatomic,assign)BOOL isFirstRequest;
-(NSString *)cacheKey;
+(id)Request;
+(id)RequestWithBlock:(EZVoidBlock)voidBlock;//初始化block
-(void)loadRequest;//加载入口
-(NSString *)requestKey;//请求的唯一识别码
+(NSString *)requestKey;//请求的唯一识别码
/**
 *  获取requestParams序列化请求的变量
 *  self.params 覆盖成员属性
 *  @return NSMutableDictionary requestParams
 */
-(NSDictionary *)requestParams;
-(NSString *)pathInfo;//自定义路由
-(NSString *)appendPathInfo; //解析路由(为Action设计)
- (BOOL)succeed;//请求是否成功
- (BOOL)sending;//请求是否在发送中
- (BOOL)failed;//请求是否失败
- (BOOL)cancled;//请求是否取消
- (void)cancle;//取消本次请求
@end
