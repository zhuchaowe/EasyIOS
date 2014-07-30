//
//  swift-bridge.h
//  swiftTest
//
//  Created by zhuchao on 14-7-15.
//  Copyright (c) 2014 year zhuchao. All rights reserved.
//

#import "Action.h"
#import "Scene.h"
#import "CacheAction.h"
#import "Model.h"
#import "SceneModel.h"
#import "SceneCollectionView.h"
#import "SceneGridView.h"
#import "SceneScrollView.h"
#import "SceneTableView.h"
#import "EzMiButton.h"
#import "EzUITapGestureRecognizer.h"
#import "RTLabel.h"
#import "DialogUtil.h"
#import "Request.h"

#define HOST_CONFIG 1
//以下配置为调用Action 类必须 配置
#define HOST_URL @"test-leway.zjseek.com.cn:8000" //服务端域名:端口
#define CLIENT   @"easyIOS"                       //自定义客户端识别
#define CODE_KEY @"code"                          //错误码key,支持路径 如 data/code
#define RIGHT_CODE 0                              //正确校验码
#define MSG_KEY  @"msg"                           //消息提示msg,支持路径 如 data/msg
