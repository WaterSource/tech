## JS-Native交互

关键词 Hybrid，Sonic

次级关键词 rn，weex

### Native和H5交互的两种方案

#### URL Scheme

url scheme 方案适用于所有的系统设备，实现方案是通过url拦截实现的，在大量数据传输上、效率上都还有问题。

基本原理

```
H5 -> 触发一个URL，需要提前沟通出协议，给各个功能标记处不同的URL
-> Native拦截URL -> Native解析URL，触发功能执行 
-> Native调用H5的方法将执行回调回调
```

协议可以类似于 `myxjpush://doSomething?param=obj`

#### JavaScriptCore / JavaScriptBridge

安卓和iOS存在调用方法差异，且本方法在Android4.2以下存在安全漏洞;iOS10-iOS8，JavaScriptCore available；

对于iOS来说，需要引入

`#import<JavaScriptCore/JavaScriptCore.h>`

##### 通过对`JSContext`注册方法实现H5对Native的调用

```
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	...
	JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.jacaScriptContext"];
	// 注册名为foo的方法
	context[@"foo"] = ^() {
		NSArray *args = [JSContext currentArguments];
		NSString *title = [NSString stringWithFormat:@"%@", [args objectAtIndex:0]];
		// something else
		
		return [NSString stringWithFormat:@"foo:%@", title];
	};
	...
}
```

##### Native调用H5

```
[uiWebView stringByEvaluatingJavaScriptFromString:@"foo(params);"];
!completion?:completion();

[wkWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
```

### JSBridge技术实现

* 设计出Native与JS交互的全局桥对象
* JS如何调用Native
	* Native如何得知api被调用
	* 分析url-参数和回调的格式
* Native如何调用JS
	* H5中api方法的注册及格式

## WKWebView 和 UIWebView 的区别

![](https://tva1.sinaimg.cn/large/006tNbRwgy1ga3cj9tazmj30hs0gz0u9.jpg)

### WK 优点

* 多进程

WKWebView 是从App内存中分离出来的，如果超过了分配的内存大小，会导致浏览器奔溃白屏，但是App不会Crash。app还会受到系统通知尝试重新加载。

UIWebView 和app共享同样的内存，当超过分配的内存大小，会导致app被系统杀掉？

* 浏览器引擎(不清楚是不是内核)

WKWebView使用的是手机Safari同样的`Nitro JavaScript`引擎，相比UIWebView的`JavaScript`引擎有性能提升。

* 异步执行处理JavaScript

WKWebView会在异步线程中处理通信

* 关于触摸延迟

在UIWebView上所有的触摸事件都会被延迟300ms，用来判断是单击还是双击事件；

在WKWebView中，只有在点击很快的时候(<~125ms)才会添加300ms延迟。原因是系统判定这会是一个"点击缩放"的手势，而不是慢点击(>~125ms)。

* 支持服务端的身份校验

```
- (void)webView:(WKWebView *)webView
 didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge 
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler { 
 	// 据说还存在bug，不一定每次都回调 2017.12
 }
```

### WK 存在的问题

#### Cookie

![](https://tva1.sinaimg.cn/large/006tNbRwgy1ga3cl4shqsj30hs0fjt99.jpg)

图是一个正常的登录Cookie认证流程，用户发起请求，后台登录之后，对浏览器写入Cookie，该Cookie会写入磁盘，在后续请求的时候会携带该Cookie，后台通过Cookie验证身份，确认登录状态；

在`UIWebView`上会经过`NSHTTPCookieStorage`统一管理Cookie，服务器返回时就写入，Web和Native能通过该对象共享Cookie；

在`WKWebView`上，`NSHTTPCookieStorage`不再是必经的流程节点，虽然同样还是会写入Cookie，但是是异步写入的，不同系统版本的延时还不相同，发起请求时也做不到实时读取Cookie。

#### 默认的跳转行为

在`UIWebView`上，如果超链接设置为`tel://12345678`之类的值，可以触发系统电话拨打；

但在`WKWebView`上，点击不会有反应，类似的系统scheme已经被屏蔽了，会在跳转问询代理中响应回调，校验scheme值之后`UIApplication`外部打开；

#### 跨域问题

`HTTPS`对`HTTPS`，`HTTP`对`HTTP`跨域默认是能载入的，但是`HTTP`想载入`HTTPS`跨域链接是会被拦截的。

#### NSURLProtocol问题

`UIWebView`是通过`NSURLConnection`处理HTTP请求，而通过Connection发出的请求都会遵循`NSURLProtocol`协议，客户端就有能力代理Web资源的下载，做统一的缓存管理和维护。

`WKWebView`上不能通过这一套方案实现，`WKWebView`的载入在单独的进程中进行，数据app无法干涉。

#### 缓存问题

`WKWebView`内部默认使用一套缓存机制，开发能控制的权限有限，在iOS8下没有办法操作，对于静态资源的更新，客户端还会出现读取缓存不更新的情况。

如果只是单个资源，可以考虑对资源地址增加时间戳避开缓存；

如果是全局都是这样，就需要手动清理缓存。iOS9之后可以在`WKWebsiteDataStore`中调用接口清理缓存。

```
NSSet *websiteTypes = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache]];
NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
[[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteTypes modifiedSince:date completionHandler:^{}];
```

而在iOS9以前，就只能通过删除文件的方案来解决，WKWebView的缓存数据是储存在`~/Library/Caches/BundleID/WebKit/`目录下。

#### 页面问题

* 退回上一页不会重新执行Script脚本，也不会触发reload事件，是因为`WKWebView`的页面管理和缓存机制导致的
* 页面键盘弹出会触发resize事件
* window.unload只有刷新页面才会触发，退出或跳转到其他页都无法触发