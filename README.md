EasyIOS
=======

a easy way to program objective-c 

采用MKNetworkKit 网络框架，修改了部分功能，底层支持网络缓存，轻松控制是否启用缓存。

集成了开源代码UIGridView 网格视图

集成了开源代码RTLabel 富文本Label

集成SVProgressHUD指示器

集成MJRefresh下拉刷新，有删改

model类整合Jastor的类库和MojoDataBase类库

整合了很多开源的优秀代码

部分函数借鉴了BeeFramework

常用类库：

Action 负责网络数据请求

Scene 一个视图相当于UIViewController,提供了快速集成网络请求和下拉刷新上拉加载的方法。

SceneTableView  一个TableView，配合scene提供了集成下拉刷新上拉加载的方法

SceneCollectionView 一个CollectionView，配合scene提供了集成下拉刷新上拉加载的方法

EasyIOS官方qq群 :340906744 欢迎大家加入讨论

* [git on oschina ](http://git.oschina.net/zhuchaowe/EasyIOS)
* [git on github ](https://github.com/zhuchaowe/EasyIOS)

###How To Install
1. Download the source code
		
		https://github.com/zhuchaowe/EasyIOS/archive/master.zip
2. Drag and drop `/Easy` folder into your project
3. Drag and drop `/Extend` folder into your project
4. Build and run

###Clone From Git
* Clone the repo (CLI)
		
		git clone git@github.com:zhuchaowe/EasyIOS.git
* Clone the repo (HTTP)
		
		https://github.com/zhuchaowe/EasyIOS.git
* Import from CocoaPods 

	Add below to Podfile and run pod install

		platform :ios
		pod 'EasyIOS', :head
		
##1.0.3版本更新

*  再也不用担心奇葩的图文混排了
*  新增字体图片支持 资源里的demo 就是一个基于 `swift`和`easyios`的字体图片演示,可以用来作为图片字典查阅
*  可扩展的字体库，字需要添加`ttf`和`json`文件就可以轻松扩展特殊字体
*  目前支持4种图片字体 `FontAwesome`、`Zocial-Regular`、`Ionicons`、`Foundation`
*  [FontAwesome 4.1](http://fortawesome.github.io/Font-Awesome/) 字体库, 包含 439 个图标
*  [Foundation icons](http://zurb.com/playground/foundation-icon-fonts-3) 字体库, 包含283 个图标
*  [Zocial Contains](http://zocial.smcllns.com/) 字体库, 包含99 个图标
*  [ionicons 1.5.2](http://ionicons.com/) 字体库, 包含601 个图标,大部分是 IOS7 style

![image](http://08dream-08dream.stor.sinaapp.com/1000035355488spec47.gif)
##1.0.2版本更新

*  fix一些头文件的引用关系，增加了swift头文件支持。
*  用swift的同学，要设置`Objective-C Bridging Header`为`${PODS_ROOT}/Headers/EasyIOS/swift-bridge.h`
*  1.0.2版本发布到了CocoaPods

##1.0.1版本更新
* 1.增加了ORM支持，从此可以实现json、object、sqlite三者之间的一键转换,可以节省很多代码,是不是很酷。
		
model类整合了Jastor的类库和MojoDataBase类库

* 2.修改了Action类中的post的参数，增加了files参数，

因此，action.POST_MSG的时候现在至少要3个参数哦

* 3.借鉴了beeframework的消息通知机制。。.默默给郭大点个赞。。

* 4.修复了一个下拉刷新的bug

* 5.提供了一键打开百度地图、苹果地图、google地图、高德地图发起调用的接口，再也不用担心看地图文档了




