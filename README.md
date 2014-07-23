EasyIOS 2.0 - program on MVVM
=======

a easy way to program objective-c 

##2.0 MVVM update
全新基于MVVM(Model-View-ViewModel)编程模式架构，开启EasyIOS开发函数式编程新篇章。

关于有疑问什么是MVVM，以及为什么IOS开发需要MVVM思想编程的，请看CocoaChina得一篇文章[用Model-View-ViewModel构建iOS App](http://www.cocoachina.com/applenews/devnews/2014/0716/9152.html)有详细介绍.

EasyIOS 2.0是基于MVVM编程思想进行构建的，封装了Scene,SceneModel,Model，Action四种模型来对IOS进行开发，4种模型的定义解决了IOS开发中ViewController承担了过多角色而造成的代码质量低下，使得结构思路更加清晰。

* 1.其中Scene就是ViewController的子类，负责仅仅负责界面的展示逻辑
* 2.Model数据模型，父类实现了ORM，可以实现json、object、sqlite三者之间的一键转换,
* 3.SceneModel 视图-数据模型，主要负责 视图与模型的绑定工作，其中binding的工作交给了ReactiveCocoa。
* 4.SceneModel包含Action成员，Action类主要负责网络数据的请求,数据缓存，数据解析工作

如果你有看Github的Trending Objective-C榜单，那你肯定是见过ReactiveCocoa了。如果你在weibo上关注唐巧、onevcat等国内一线知名开发者。那也应该听说过ReactiveCocoa了。 
ReactiveCocoa简称RAC，就是基于响应式编程思想的Objective-C实践，它是Github的一个开源项目，你可以在[这里](https://github.com/ReactiveCocoa/ReactiveCocoa)找到它。


采用MKNetworkKit 网络框架，修改了部分功能，底层支持网络缓存，轻松控制是否启用缓存。

采用ReactiveCocoa 框架，实现响应式编程，减少代码复杂度。

集成了开源代码UIGridView 网格视图

集成了开源代码RTLabel 富文本Label

集成SVProgressHUD指示器

集成MJRefresh下拉刷新，有删改

model类整合Jastor的类库和MojoDataBase类库

整合了很多开源的优秀代码

部分函数借鉴了BeeFramework

常用类库：

Action 负责网络数据请求

Model 负责数据存储

SceneModel 负责Scene与Model的绑定，调用action进行数据请求

Scene 一个视图相当于UIViewController,提供了快速集成网络请求和下拉刷新上拉加载的方法。

SceneTableView  一个TableView，配合scene提供了集成下拉刷新上拉加载的方法

SceneCollectionView 一个CollectionView，配合scene提供了集成下拉刷新上拉加载的方法

EasyIOS官方qq群 :340906744 欢迎大家加入讨论

* [git on oschina ](http://git.oschina.net/zhuchaowe/EasyIOS)
* [git on github ](https://github.com/zhuchaowe/EasyIOS)

###How To Install
* Import from CocoaPods 
Add below to Podfile and run pod install

    platform :ios

    pod 'EasyIOS', :head

##2.0版本更新

* 架构修改，基于MVVM架构
* 把SceneModel从Scene中剥离出来，并且加入响应式编程框架ReactiveCocoa
* ReactiveCocoa中文使用说明教程 [ReactiveCocoa2实战](http://limboy.me/tech/2014/06/06/deep-into-reactivecocoa2.html)
* ReactiveCocoa 在github上有开源项目[ReactiveCocoa2](https://github.com/ReactiveCocoa/ReactiveCocoa)

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




