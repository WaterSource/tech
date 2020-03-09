## H5 加载优化

[WKWebView那些坑 腾讯bugly](https://mp.weixin.qq.com/s/rhYKLIbXOsUJC_n6dt9UfA?)


* NSR: Native side rendering，客户端侧实现页面结构拼接，进而实现页面渲染的处理技术
* SSR: Server side rendering，服务端渲染，服务端完成页面结构拼接的页面处理技术
* CSR: Client side rendering，客户端渲染，页面在用户的浏览器环境中通过执行JS完成页面结构拼接，进而实现页面渲染
* PWA: Progressive Webb Apps，渐进式Web应用【iOS无法使用】

### 网页的加载过程

![](https://tva1.sinaimg.cn/large/00831rSTgy1gcbd2bxj0nj30fa08lwf0.jpg)

* native的耗时: 主要是WebView的创建、初始化
* 网络耗时: DNS + TCP(SSL) + 服务端渲染耗时(如果采用SSR) + Document下载
* 渲染耗时: Ajax(CSR) + JS scripting(CSR耗时) + 浏览器Painting(内核)

#### 监控耗时情况

通过JS方法`performance.timing`

#### 有颜当时的情况

![](https://tva1.sinaimg.cn/large/00831rSTgy1gcchue6mimj30pc0ffwgl.jpg)

* 浏览器初始化 500
* DNS查询耗时 5
* TCP链接耗时 143
* request请求耗时 36
* 解析dom树耗时 72
* 白屏时间 335
* dom树 ready时间 896
* dom树 load时间 0
* onload总时间 965

### 客户端常规优化手段

* webview提前初始化
* DNS解析
* HTTP缓存
* 数据预请求、数据缓存

#### 前端或者后端的优化手段

* CDN分发
* 动态直出，前端代码更新之后，服务器直接输出html
* 复用客户端使用的域名和链接
* 骨架屏: 会先展示页面的空白版本，然后通过替换各个占位的部分达到逐渐展示

### UIWebView可以怎么处理

NSURLProtocol 转发

[参考地址](https://www.jianshu.com/p/ae5e8f9988d8)

### WKWebView可以怎么处理

```
私有api
+ [WKBrowsingContextController registerSchemeForCustomProtocol:]
```

```
Class cls = NSClassFromString(@"WKBrowsingContextController”); 
SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:"); 
if ([(id)cls respondsToSelector:sel]) { 
           // 注册http(s) scheme, 把 http和https请求交给 NSURLProtocol处理 
           [(id)cls performSelector:sel withObject:@"http"]; 
           [(id)cls performSelector:sel withObject:@"https"]; 
}
```

存在的问题

* post 请求 body 数据被清空
* ATS支持不足，Allow Arbitrary Loads = NO时，会使得WKWebView发起的所有http请求被阻塞

[参考链接](https://www.jianshu.com/p/8f5e1082f5e0)

#### Cookie的获取问题

### VasSonic



### 浏览器工作原理

#### 浏览器高层结构

* 用户界面
* 浏览器引擎: 在用户界面和呈现引擎之间传送指令。
* 呈现引擎: 负责显示请求的内容。如果请求的内容是HTML，他就负责解析HTML和CSS内容，并将解析后的内容显示在屏幕上。
* 网络
* 用户界面后端: 用于绘制基本的窗口小部件，比如组合框和窗口。公开了与平台无关的通用接口，而在底层使用操作系统的用户界面方法。
* JavaScript解释器: 用于解析和执行JavaScript代码。
* 数据存储: Cookie一类的，需要在硬盘上保存数据的模块。

#### 呈现引擎

Safari和Chrome使用的都是webkit。

![](https://tva1.sinaimg.cn/large/00831rSTgy1gcc3zsfaraj30hc0810tc.jpg)

#### 预渲染的延伸问题

![](https://tva1.sinaimg.cn/large/00831rSTgy1gcc7tnwip3j30fa08lmxl.jpg)

