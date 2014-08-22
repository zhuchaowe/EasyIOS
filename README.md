![image](https://raw.githubusercontent.com/zhuchaowe/EasyIOS/gh-pages/images/logo.png)

EasyIOS 2.0 - program on MVVM
=======

EasyIOS is a new generation of development framework based on `Model-View-ViewModel` which makes faster and easier app development, Build your app by geek's way.



[EasyIOS论坛](http://easyios.08dream.com)

[源码下载](https://github.com/zhuchaowe/EasyIOS/archive/master.zip)

EasyIOS官方qq群 :[340906744](http://shang.qq.com/wpa/qunwpa?idkey=562d002e275a8199081313b00580fb7111a4faf694216a239064d29f5238bc91) 欢迎大家加入讨论

[教程在Wiki Paper](https://github.com/zhuchaowe/EasyIOS/wiki)

[json转Model工具 ModelCoder](https://github.com/zhuchaowe/ModelCoder) 

##2.0 The MVVM(Model-View-ViewModel)
全新基于`MVVM(Model-View-ViewModel)`编程模式架构，开启EasyIOS开发函数式编程新篇章。

EasyIOS 2.0类似`AngularJs`，最为核心的是：`MVVM`、`ORM`、模块化、自动化双向数据绑定、等等

2.0的demo在这里[MVVM Demo for EasyIOS](https://github.com/zhuchaowe/MVVM-Demo--EasyIOS-)，供大家学习。

喜欢`swift`的同学，同样有`swift`的2.0 demo [RACSwift for EasyIOS](https://github.com/zhuchaowe/RACSwift)，供大家学习。

关于有疑问什么是MVVM，以及为什么IOS开发需要MVVM思想编程的，请看文章[用Model-View-ViewModel构建iOS App](http://swift.08dream.com/index.php?s=/Home/Article/detail/id/10036.html)有详细介绍.

EasyIOS 2.0是基于MVVM编程思想进行构建的，封装了Scene,SceneModel,Model，Action四种模型来对IOS进行开发，4种模型的定义解决了IOS开发中ViewController承担了过多角色而造成的代码质量低下，使得结构思路更加清晰。

* 1.其中`Scene`就是`ViewController`的子类，仅仅负责界面的展示逻辑
* 2.`Model`数据模型，父类实现了ORM，可以实现json、object、sqlite三者之间的一键转换,
* 3.`SceneModel` 视图-数据模型，主要负责 视图与模型的绑定工作，其中binding的工作交给了`ReactiveCocoa`。
* 4.`SceneModel`包含`Action`成员，`Action`类主要负责网络数据的请求,数据缓存，数据解析工作

如果你有看Github的Trending Objective-C榜单，那你肯定是见过`ReactiveCocoa`了。如果你在微博上关注唐巧、onevcat等国内开发者。那也应该听说过`ReactiveCocoa`了。 
`ReactiveCocoa`简称RAC，就是基于响应式编程思想的Objective-C实践，它是Github的一个开源项目，你可以在[这里](https://github.com/ReactiveCocoa/ReactiveCocoa)找到它。


采用`MKNetworkKit` 网络框架，修改了部分功能，底层支持网络缓存，轻松控制是否启用缓存。

采用`ReactiveCocoa` 框架，实现响应式编程，减少代码复杂度。

集成了开源代码`RTLabel` 富文本Label

集成`MJRefresh`下拉刷新，有删改

`Model`类整合`JsonModel`的类库和`MojoDataBase`类库

整合了很多开源的优秀代码

部分函数借鉴了`BeeFramework`

常用类库：

`Action` 负责网络数据请求

`Model` 负责数据存储

`SceneModel` 负责`Scene`与`Model`的绑定，调用action进行数据请求

`Scene` 一个视图相当于`UIViewController`,提供了快速集成网络请求和下拉刷新上拉加载的方法。

`SceneTableView`  一个`TableView`，配合`Scene`提供了集成下拉刷新上拉加载的方法

`SceneCollectionView` 一个`CollectionView`，配合`Scene`提供了集成下拉刷新上拉加载的方法



* [git on oschina ](http://git.oschina.net/zhuchaowe/EasyIOS)
* [git on github ](https://github.com/zhuchaowe/EasyIOS)

###How To Install
* Import from CocoaPods 
* Add below to Podfile and run pod install

    	platform :ios
    	pod 'EasyIOS', :head
    	
* If you use swift , please click [here](https://github.com/zhuchaowe/RACSwift)


##2.0.2版本更新

* 新增gcd封装`GCDObjC`,告别CocoaTouch原生难记的gcd调用方法
* 新增正则表达式封装`RegExCategories`,可以轻松的开始码正则表达式了
* 新增缓存处理封装`TMCache`,方便手动操作数据缓存(MK的自动缓存没有采用TMCache)
* Model层升级：[MojoDatabase+JsonModel](https://github.com/zhuchaowe/mojo-database)新增自动检测、自动创建数据表，新增查询方法 ，order by、group by、limit等等方法 
* 新增功能[教程在Wiki Paper](https://github.com/zhuchaowe/EasyIOS/wiki)

##2.0.1版本更新

* 修改pod依赖
* [FontIcon](https://github.com/zhuchaowe/FontIcon)剥离项目，单独维护
* Model层修改：移除Jastor，添加JsonModel[MojoDatabase+JsonModel](https://github.com/zhuchaowe/mojo-database)剥离项目，单独维护。
* 增加懒人程序代码生成工具[ModelCoder](https://github.com/zhuchaowe/ModelCoder) 
* 移除部分非必要类库，代码整合
* 本着引导大家编程更easy的原则,增加`Easykit`、`FLKAutoLayout`类


##2.0版本更新

* 架构修改，基于MVVM架构
* 把`SceneModel`从`Scene`中剥离出来，并且加入响应式编程框架`ReactiveCocoa`
* `ReactiveCocoa`中文使用说明教程 [ReactiveCocoa2实战](http://swift.08dream.com/index.php?s=/Home/Article/detail/id/10035.html)
* `ReactiveCocoa` 在github上有开源项目[ReactiveCocoa2](https://github.com/ReactiveCocoa/ReactiveCocoa)

##1.0.3版本更新

*  再也不用担心奇葩的图文混排了
*  新增字体图片支持 资源里的demo 就是一个基于 `swift`和`easyios`的字体图片演示,可以用来作为图片字典查阅
*  可扩展的字体库，字需要添加`ttf`和`json`文件就可以轻松扩展特殊字体
*  目前支持4种图片字体 `FontAwesome`、`Zocial-Regular`、`Ionicons`、`Foundation`
*  [FontAwesome 4.1](http://fortawesome.github.io/Font-Awesome/) 字体库, 包含 439 个图标
*  [Foundation icons](http://zurb.com/playground/foundation-icon-fonts-3) 字体库, 包含283 个图标
*  [Zocial Contains](http://zocial.smcllns.com/) 字体库, 包含99 个图标
*  [ionicons 1.5.2](http://ionicons.com/) 字体库, 包含601 个图标,大部分是 IOS7 style

![image](http://08dream-08dream.stor.sinaapp.com/100003535548847.gif)

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




