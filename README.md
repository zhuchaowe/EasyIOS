![image](https://raw.githubusercontent.com/zhuchaowe/EasyIOS/gh-pages/images/logo.png)

EasyIOS  - Happy New Year 2015
=======

[![Pod Version](http://img.shields.io/cocoapods/v/EasyIOS.svg)](http://easyios.08dream.com)
[![Pod Version](http://img.shields.io/cocoapods/p/EasyIOS.svg)](http://cocoadocs.org/docsets/EasyIOS/)
[![License](http://img.shields.io/cocoapods/l/EasyIOS.svg)](http://cocoadocs.org/docsets/EasyIOS/)
[![qq](http://img.shields.io/badge/QQ%E7%BE%A4-340906744-green.svg)](http://shang.qq.com/wpa/qunwpa?idkey=562d002e275a8199081313b00580fb7111a4faf694216a239064d29f5238bc91)


EasyIOS is a new generation of development framework based on `Model-View-ViewModel` which makes faster and easier app development, Build your app by geek's way.

* [EasyIOS官方主页](http://easyios.08dream.com)

* [EasyIOS官方论坛-IOSX](http://www.iosx.me)

* EasyIOS官方qq群 :[340906744](http://shang.qq.com/wpa/qunwpa?idkey=562d002e275a8199081313b00580fb7111a4faf694216a239064d29f5238bc91) 欢迎大家加入讨论

* [EasyRSS](https://github.com/zhuchaowe/EasyRSS):基于EasyIOS 2.2.2 的开源项目,EasyIOS的官方Demo

* [RACSwift for EasyIOS](https://github.com/zhuchaowe/RACSwift):EasyIOS swift 版本Demo

* [教程在Wiki Paper](https://github.com/zhuchaowe/EasyIOS/wiki)

* [json转Model工具 ModelCoder](https://github.com/zhuchaowe/ModelCoder) 


##EasyIOS 以提升开发效率为宗旨

* 代码分离 -`Model-View-ViewModel`- 分离ViewController中的大量逻辑代码，解决ViewController承担了过多角色而造成的代码质量低下。增加视图与模型的绑定特性。

* 自动持久化 -`Model to Db`– 我再也不想思考如何实现持久化了。在我的想法里，将模型对象直接扔到一个bucket里，然后它就能自动的对数据进行存储、缓存、合并以及唯一化。我应当关注于描述对象间的属性和联系，以及我希望它们分组的方式。其他的实现细节都应该是不可见的。 

* 自动RESTful API –`Json to Model`- 一旦我给程序发出指令，将一个API响应对应到一个数据对象，网络和JSON转换应该被自动完成。我只想关注如何将JSON中那些项目展示给用户。 

* 有表现力的触发器和响应 -`ReactiveCocoa`– 我想用源于响应意图（Intent）的语法来描述事件的响应和触发器，我不关心它们间的连接是如何实现的，并且这些连接也不应该在重构时出错。

* 简洁明了的网络请求 -`Action` and `Request`- 对于简单的GET、POST请求，可以进行对象化操作，我只想告诉程序，链接在哪里，有哪些参数，接下来就自动拉取到想要的数据，顺便帮我把缓存也做齐了，也是极好的。

* 便捷的UI布局 – `FLKAutolayout`-更加便捷的进行autolayout布局,不管你使用springs & struts或者AutoLayout，每种方法都需要你明确相关视图如何排列。你需要花大量的时间编写和修正这些排列，特别是现在有这么多设备需要适配 的情况下。没有什么是自动写好的，UI布局依赖于对细节的不断调整。推荐开发期间Debug工具[FLEX](!https://github.com/Flipboard/FLEX),`pod 'FLEX', '~> 1.1.1'`需要手动集成，发布release版本时请删除。
* 友好的线程控制 -`GCDObjC`-
* 便捷的正则匹配 
* 富文本的Label
* and so on……

##The MVVM(Model-View-ViewModel)
全新基于`MVVM(Model-View-ViewModel)`编程模式架构，开启EasyIOS开发函数式编程新篇章。

EasyIOS 2.0类似`AngularJs`，最为核心的是：`MVVM`、`ORM`、模块化、自动化双向数据绑定、等等

喜欢`swift`的同学，同样有`swift`的2.0 demo [RACSwift for EasyIOS](https://github.com/zhuchaowe/RACSwift)，供大家学习。

关于有疑问什么是MVVM，以及为什么IOS开发需要MVVM思想编程的，请看文章[用Model-View-ViewModel构建iOS App](http://easyios.08dream.com/index.php?s=/Home/Article/detail/id/10036.html)有详细介绍.

EasyIOS 2.0是基于MVVM编程思想进行构建的，封装了Scene,SceneModel,Model，Action四种模型来对IOS进行开发，4种模型的定义解决了IOS开发中ViewController承担了过多角色而造成的代码质量低下，使得结构思路更加清晰。

* 1.其中`Scene`就是`ViewController`的子类，仅仅负责界面的展示逻辑
* 2.`Model`数据模型，父类实现了ORM，可以实现json、object、sqlite三者之间的一键转换,
* 3.`SceneModel` 视图-数据模型，主要负责 视图与模型的绑定工作，其中binding的工作交给了`ReactiveCocoa`。
* 4.`SceneModel`包含`Action`成员，`Action`类主要负责网络数据的请求,数据缓存，数据解析工作

如果你有看Github的Trending Objective-C榜单，那你肯定是见过`ReactiveCocoa`了。如果你在微博上关注唐巧、onevcat等国内开发者。那也应该听说过`ReactiveCocoa`了。 
`ReactiveCocoa`简称RAC，就是基于响应式编程思想的Objective-C实践，它是Github的一个开源项目，你可以在[这里](https://github.com/ReactiveCocoa/ReactiveCocoa)找到它。


二次封装`AFNetworking`，集成到Action，增加了网络缓存功能，轻松控制是否启用缓存。

采用`ReactiveCocoa` 框架，实现响应式编程，减少代码复杂度。

`Model`类整合`JsonModel`的类库和`MojoDataBase`类库

整合了很多开源的优秀代码

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

    	platform :ios, "6.0"
    	pod 'EasyIOS', '~> 2.2.2'
    	pod 'EasyIOS-Extention', '~> 1.2'
    	
* If you use swift , please click [here](https://github.com/zhuchaowe/RACSwift)

##2.2.2 版本更新
* 指定RAC最高版本号为2.4.4
* Action类POST方法增加缓存功能
* Request类增加设置http头信息

##2.2版本更新
* 修改Action类中的配置方式：由原来的宏调用改为类方法配置
* 针对IOS8优化
* 为UIScrollView增加下拉放大效果
* 新增`EZNavigationController`类，解决ios7中快速push容易crash的问题
* 重写下拉刷新，与上拉加载，完全解耦，支持自定义UI。
* 新增AutoLayoutCell自适应高度的cell，以及UIScrollView的AutoLayout实现自适应contentSize
* 智能键盘，防止键盘遮盖输入框
* 新增强大的XAspect,完美实现代码解耦，再一次为UIViewController减负
* 兼容IOS8的`UIAlertController`与IOS7的`UIActionSheet`、`UIAlertView`
* Action类新增Download下载方法
* `EasyIOS-Extention`分离可选的第三方类库
* 移除了`RTLabel`,`EzUILabel`
* 修复部分bug 
* ……


##2.1版本更新
* 多谢各位小伙伴们的支持以及不断的提出Issues，清晰的指出了了EasyIOS的优化项,本次更新主要针对网络访问Action类
* 2.1版本移除了`MKNetWorkKit`，基于现有的api重新封装了`AFNetworking`，并且加入了缓存控制。
* 如果利用`Action`类来发起请求的小伙伴可以体验到无痛升级的快感。。
* 同时移除`UIImageView+MKNetWorkKit`替换为大家熟悉的`SDWebImage`，解决图片闪烁问题。
* 修复部分循环引用的bug

##2.0.3版本更新
* 紧急修复2.0.2 model层初始化数据为nil的bug
* 移除`EUIGestureRecognizer`
* 增加`SHGestureRecognizerBlocks`

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




