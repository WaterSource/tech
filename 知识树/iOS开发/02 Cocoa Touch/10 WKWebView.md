## WKWebView

iOS8的时候推出的，在iOS9趋于稳定，在iOS12官方不再维护`UIWebView`之后，没有理由再拒绝它。

`WKWebView`本质上是系统中的另一个进程，有别于`UIWebView`，内存过大时，也只是会让自身出现白屏。

其实在各方面相较于`UIWebView`都是优势，盗用网上的数据

![](https://tva1.sinaimg.cn/large/00831rSTgy1gcgjvn1yfzj30yf0u00ya.jpg)

	Tip: 在一些用webGL渲染的复杂页面，使用WKWebView总体的内存占用（App Process Memory + Other Process Memory）不见得比UIWebView少很多。
	
### 问题以及对应的解决方案

#### 1.白屏问题

这里说的白屏不是加载中的白屏时间，而是因为内存占用过高的时候，`WebContent Process`会crash的情况，外在的表现就是白屏。

已经白屏的情况，URL会变为nil，再执行`relaod`刷新已经没用了，对于常驻的H5页面影响会很大。

* 实现代理 `WKNavigtionDelegate `

`- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView`

在方法中执行`[webView reload]`，这个时候URL的值还不是nil

* 检测 `webView.title` 是否为空

可以在`viewWillAppear`时检测`webView.title`来确定页面是否白屏。

但是需要在浏览器初始化时，设置一个默认的`webView.title`。





