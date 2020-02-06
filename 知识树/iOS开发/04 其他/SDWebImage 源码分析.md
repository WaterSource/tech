## SDWebImage 源码分析

![](https://tva1.sinaimg.cn/large/006tNbRwgy1g9x6yws3gij31dn0u0ax9.jpg)

* UI分类扩展
	* UIButton(WebCache)
	* MKAnnotationView(WebCache) 地图大头针
	* UIImageView(WebCache)
	* UIImageView(HighlightedWebCache)
	* FLAnimatedImageView(WebCache) GIF

这些子类内部都会调用`UIView(WebCache)`分类的`sd_internalSetImageWithURL`方法来做图片加载请求。具体通过`SDWebImageManager`调用来实现的。
	
* 工具类

	* NSData+ImageContentType 根据图片数据获取图片的类型； GIF/PNG等；
	* SDWebImageCompat 根据屏幕的分辨倍数成倍放大或者缩小图片大小；
	* SDImageCacheConfig 图片缓存策略记录；是否解压缩、是否允许iCloud、是否允许内存缓存、缓存时间等。默认的缓存时间是一周；
	* UIImage+MultiFormat UIImage和NSData之间的转换处理
	* UIImage+GIF 对图片是否是GIF格式做判断。
	* SDWebImageDecoder 根据图片的情况，做图片的解压缩处理，并且根据图片的情况决定如何处理解压缩。
	
* 核心类

	* SDImageCache 负责缓存工作
	* SDWebImageManager 持有`SDWebImageCache`和`SDWebImageDownloader`；为`UIView`及其子类提供加载图片的统一接口，管理正在操作的集合，对各种加载选项的处理；
	* SDWebImageDownloader 实现图片加载的具体处理；在缓存读取或者创建`SDWebImageDownloaderOperation`来下载图片；
	* SDWebImageDownloaderOperation 自定义的Operation子类，主要实现图片的下载操作，下载完成的图片解压缩、Operation生命周期管理；
	* UIView+WebCache 

### 加载图片流程

![](https://tva1.sinaimg.cn/large/006tNbRwgy1g9ykdo0zw0j321m0r4tdz.jpg)

### 线程模型

* 下载队列 `SDWebImageDownloaderOperation`
	* 默认6线程的异步队列
* 读取缓存队列、写缓存队列
	* SDImageCache
	* 串行队列 异步任务
* 图片解码队列
	* 串行队列 异步任务

