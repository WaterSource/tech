## App完整启动流程


[参考链接](https://www.jianshu.com/p/a51fcabc9c71)

### 名词解释

#### mach-O

* Executable 可执行文件
* Dylib 动态库
* Bundle 无法被连接的动态库，只能通过dlopen()加载
* Image 指的是Executable，Dylib或者Bundle的一种
* Framework 动态库和对应的头文件和资源文件的集合

mach-O大致可以分为三部分

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbzf8mgvzkj30pe0rsgp3.jpg)

* Header 头部，包含可以执行的CPU架构，比如x86，arm64
* Load commands 加载命令，包含文件的组织架构和在虚拟内存中的布局方式
* Data 数据，包含load commands中需要的各个段的数据，每个段(Segment)的数据，每个Segment的大小都是Page的整数倍

#### dyld

dynamic loader，它的作用是加载一个进程所需要的image，苹果开源

#### Virtual Memory

虚拟内存，简历在屋里内存和进程之间的中间层

#### Dirty Page & Clean Page

脏页

### 启动过程

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbzfhbypegj311s0bk3zf.jpg)

* 加载dyld到app进程
* 加载动态库(包括所依赖的所有动态库)
* Rebase
* Bind
* 初始化 ObjC Runtime
* 其他的初始化代码

#### 加载动态库

dyld会首先读取mach-o文件的Header和load commands。
接着通过可执行文件知道所有依赖的动态库，再递归查找动态库所依赖的动态库。最后全部加载完成。

#### Rebase & Bind

##### 保障应用安全的 ASLR和Code Sign

ASLR是地址荣建布局随机化。App被启动的时候，程序会被映射到逻辑的地址空间，这个逻辑的地址空间有一个起始地址，ASLR就使得这个起始地址是随机的。避免黑客通过起始地址+偏移量找到函数的地址。

* rebase 修正内部的指针指向
* Bind 修正外部指针指向

#### Objective C

oc是动态语言，在执行main之前，需要把类的信息都注册到一个全局的table中，同时category实现了类的同名方法后，类中的  方法会被覆盖。

### Initialize

* +load
* C/C++ 静态初始化对象和标记为 `attribute(constructor)`的方法

其中swift上已经弃用了 +load

### 启动时间

启动时间在小于400ms是最佳的，从点击图标到显示Launch Screen，到Launch Screen小时的时间为400ms。

但是不可以大于20s，会被系统杀掉。

### 检测启动时间

在Xcode中，可以通过设置环境变量来查看App的启动时间，`DYLD_PRINT_STATISTICS`和`DYLD_PRINT_STATISTICS_DETAILS`。

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbzplxhlbjj31cm0oeq5z.jpg)

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbzpm8opsjj30vk0c4wgx.jpg)


### 优化启动时间

启动时间可以分成两部分，main函数前，main函数到第一个界面的viewDidAppear。

#### Main函数后

* `didFinishLaunchingWithOptions` `applicationDidBBecomeActive`
* 初始化Window，初始化基础的ViewController结构(很可能是UINavigationViewController + UITabViewController)
* 获取数据(Local DB / Network),展示给用户

能延迟执行的就延迟执行，不能延迟执行的就放到后台执行；

#### Main函数之前

Main函数之前是iOS系统的工作所以更具有通用型；

##### dylibs

* 合并减少第三方动态库，系统的动态库存在缓存加载速度会快；

##### Rebase & Bind & ObjC Runtime

rebase和bind都是解决指针引用的问题。对于objc来说，主要的时间会消耗在Class/Method的符号加载上，所以常见的优化方案是:

* 减少 `__DATA` 段中的指针数量
* 合并Category和功能类似的类
* 删除无用的方法和类
* 多使用Swift Struct，因为Swift Struct是静态分发的

