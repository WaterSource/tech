## VasSonic

### 原始情况

![](https://tva1.sinaimg.cn/large/00831rSTgy1gcj1fnprhrj30qo0k0765.jpg)

* 用户点击
	* webView初始化
* WebView请求指定URL
	* 完成http或者https的链接，通过DNS解析到CDN地址
	* 访问CDN地址请求HTML加载页面
		* html会触发下载.css和.js文件
			* 本地离线包缓存可以针对这两个文件做处理
* 会有不同策略下的渲染策略
	* NSR: Native side rending，客户端渲染
	* SSR: Server side rending，服务器渲染
	* CSR: Client side rending，浏览器渲染

### 初步优化

* WebView对象复用池
	* 700ms-900ms

* 网页的静态直出
	* 前端代码更新之后，通过NodeJS实现渲染，输出包含数据的HTML文件
	* webview请求的时候可以直接在CDN得到首屏渲染完成的HTML文件

* 离线预推(离线包)
	* 离线包解决弱网情况下的内容展示
	* 提前获取到html/css/js文件
	* 更新的情况下，通过BsDiff做二进制差分，生成增量包
		* 可以从300kb减少到100kb以内

### 完整VasSonic

页面内容需要满足个性化推荐

* 并行加载
	* 拦截UIWebView的请求
	* 通过独立的线程，请求url，将结果返回给WebView

* 数据模板
	* 完整的页面内容会分为4个部分
		* html: 完整页面
		* data: 可变数据
		* temp: 模板
		* rsp: 配置文件

### 缓存策略

* OfflineStore表示仅仅缓存，不刷新页面
* OfflineStoreRefresh表示既缓存又刷新页面
* OfflineRefresh表示不缓存，仅仅刷新页面
* OfflineDisable表示使本地缓存失效

#### 首次加载

状态码200，根据请求策略执行缓存

#### 非首次加载

* 状态码304
	* 页面内容完全不变，只更新配置文件的时间戳
	
* 状态码200
	* 检查返回头，模板是否有更新
	* 重新加载数据，模板按需更新

### 再进一步，VasSonic 2.0，Local Server

* 增加eTag
	* 完整网页的sha1码
	
* 增加template-tag
	* 模板文件的sha1码

* 请求返回状态码200，检查两个tag值，确定需要更新的部分

[参考链接](https://www.jianshu.com/p/def800b91cb0)