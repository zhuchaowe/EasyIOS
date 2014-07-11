EasyIOS
=======

a easy way to program objective-c 

采用MKNetworkKit 网络框架，修改了部分功能，底层支持网络缓存，轻松控制是否启用缓存。

集成了开源代码UIGridView 网格视图

集成了开源代码RTLabel 富文本Label

集成SVProgressHUD指示器

集成MJRefresh下拉刷新，有删改

model类整合Jastor的类库和MojoDataBase类库



部分函数借鉴了BeeFramework

常用类库：

Action 负责网络数据请求

Scene 一个视图相当于UIViewController,提供了快速集成网络请求和下拉刷新上拉加载的方法。

SceneTableView  一个TableView，配合scene提供了集成下拉刷新上拉加载的方法

SceneCollectionView 一个CollectionView，配合scene提供了集成下拉刷新上拉加载的方法

EasyIOS官方qq群 :340906744 欢迎大家加入讨论

* [git on oschina ](http://git.oschina.net/zhuchaowe/EasyIOS)
* [git on github ](https://github.com/zhuchaowe/EasyIOS)

##1.0.1版本更新
#####1.增加了ORM支持，从此可以实现json、object、sqlite三者之间的一键转换,可以节省很多代码,是不是很酷。
		
model类整合了Jastor的类库和MojoDataBase类库

#####2.修改了Action类中的post的参数，增加了files参数，

因此，action.POST_MSG的时候现在至少要3个参数哦

#####3.又去偷代码了，借鉴了beeframework的消息通知机制。。.默默给郭大点个赞。。

#####4.修复了一个下拉刷新的bug

#####5.提供了一键打开百度地图、苹果地图、google地图、高德地图发起调用的接口，再也不用担心看地图文档了





