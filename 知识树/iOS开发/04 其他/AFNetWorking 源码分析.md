## AFNetWorking 源码分析

### 目录结构区分

![](https://tva1.sinaimg.cn/large/006tNbRwgy1g9v7y5etwfj307z0m8n5d.jpg)

* 网络通信模块 (AFURLSessionManager、AFHTTPSessionManager)
* 网络状态监听模块 (Reachability)
* 网络通信安全策略模块 (Security)
* 网络通信信息序列化/反序列化模块 (Serialization)
* 对于iOS UIKit的扩展

### 模块

#### NSURLConnection (已于iOS9废弃不建议使用)

主要是对NSURLConnection进一步的封装，主要的核心类有

* AFURLConnectionOperation
* AFHTTPRequestOperationManager
* AFHTTPRequestOperation

#### NSURLSession

七层网络协议中有 物理层->数据链路层->网络层->传输层->会话层->表示层->应用层

`NSURLSession`可以理解为会话层，用于系统管理网络接口的创建、维护、删除等工作，会话层以下的工作已经封装好了。

创建`NSURLSession`会需要用到`NSURLSessionConfiguration`，涉及到超时、缓存策略、链接需求的策略。

如果`NSURLRequest`中也做了一些配置，那么`session`也会遵循`NSURLRequest`的配置，但是如果`NSURLSessionConfiguration`有更加严格的设定，会以`configuration`的为主。

`NSURLSession`可以通过api生成各类`task`用于不同场景，`task`需要执行`resume`开启下载。

---

`AFN`中对应`NSURLSession`的封装类为

* AFURLSessionManager 父类
* AFHTTPSessionManager 子类

`AFHTTPSessionManager`中维护的是`operationQueue`最大1个异步任务的串行队列，用于`NSURLSession`的代理回调。

#### Reachability

提供网络状态相关的接口

* AFNetworkReachabilityManager

#### Security

安全性相关的接口

* AFSecurityPolicy

##### 数字证书

证书中包含持有者的信息、公钥、证明该证书有效的数字签名。

接收端收到一份数字证书cer1后，对证书的内容做hash得到H1；然后在签发该证书的机构CA1的数字证书中找到公钥，对证书上的数字签名进行解密，得到证书cer1签名的hash摘要H2；H1H2相等，则可以证明证书内容没有被篡改；

非对称加密的一种使用场景，用于签名。使用了私钥进行签名，公钥进行验证。

##### SSL Pinning

可以理解为证书绑定，客户端直接保存服务端的证书，建立https连接时直接对比服务端返回的证书和客户端保存的证书是否一样。不再去系统的信任证书机构里寻找验证。

哪怕中间人破解客户端，取到了客户端的保存的证书，可以通过连接的验证。但是后续的流程中，中间人没有证书的私钥也无法破解内容。

---

![](https://tva1.sinaimg.cn/large/006tNbRwgy1g9wnkpxfn9j30g40ert9z.jpg)

`AFSecurityPolicy`中有三种验证模式

* AFSSLPinningModeNone
	
	不做SSL pinning，只跟浏览器一样在系统的信任机构列表里验证服务端返回的证书。自己服务器生成的证书，这里不会通过。
	
* AFSSLPinningModeCertificate

	表示使用证书绑定方式验证证书，需要客户端保存有服务端的证书拷贝。验证会分为2步，首先会验证证书的域名/有效期等信息，第二步对比服务端返回的证书和客户端持有的证书是否一致。

* AFSSLPinningModePublicKey

	同样是使用证书绑定的方式验证，需要客户端保存有服务端的证书拷贝。但是只会验证证书的公钥，不会验证有效期等信息。只要公钥是正确的就可以保证不会被窃听，中间人没有私钥，无法破译数据。

#### Serialization

数据解析相关接口

* AFURLRequestSerialization
* AFURLResponseSerialization

在组件请求的过程中，涉及到一个对象类型

```
@interface AFQueryStringPair: NSObject
```

辅助记录参数键值，协助将多格式的参数转换为字符

```
@{ 
     @"name" : @"bang", 
     @"phone": @{@"mobile": @"xx", @"home": @"xx"}, 
     @"families": @[@"father", @"mother"], 
     @"nums": [NSSet setWithObjects:@"1", @"2", nil] 
} 
-> 
@[ 
     field: @"name", value: @"bang", 
     field: @"phone[mobile]", value: @"xx", 
     field: @"phone[home]", value: @"xx", 
     field: @"families[]", value: @"father", 
     field: @"families[]", value: @"mother", 
     field: @"nums", value: @"1", 
     field: @"nums", value: @"2", 
] 
-> 
name=bang&phone[mobile]=xx&phone[home]=xx&families[]=father&families[]=mother&nums=1&num=2
}
```

#### UIKit

提供了在网络请求过程中与UI界面显示相关的接口

### AFURLSessionTaskSwizzling私有类的说明

在iOS7和iOS8以上的系统，`NSURLSessionTasks`的具体实现有不同。

* `NSURLSessionTasks`是一个类族，初始化`Task`的时候不确定初始化的是哪一个子类；也不能通过`+class`方法获取到类信息，必须要创建一个实例，通过`-class`方法才可知
* iOS7时，继承关系为 `__NSCFLocalDataTask`-> `__NSCFLocalSessionTask` -> `__NSCFURLSessionTask`
* iOS8及以上时，继承关系为 `__NSCFLocalDataTask`-> `__NSCFLocalSessionTask` -> `NSURLSessionTask`
* iOS7，`__NSCFLocalSessionTask`和`__NSCFURLSessionTask`都实现了`resume`和`suspend`方法，但是都不调用父类实现。iOS8，只有`NSURLSessionTask`实现了`resume`和`suspend`方法。所以需要在7系统让`resume`和`suspend`调用的是`NSURLSessionTask`的具体实现。

### 总结

* `AFURLSessionManager`用字典维护了一个task和taskdelegate对象的关系，将部分的代理放在了`TaskDelegate`类中，降低代码的复杂度。
* 通过block返回请求过程中的各步骤状态