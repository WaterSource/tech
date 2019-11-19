## UIApplication

UIApplication的核心作用是提供了iOS程序运行期间的控制和协作工作。

它的主要工作室处理用户事件，会持有一个队列，把所有的用户事件都放入队列里，逐个处理。在处理的时候，会把当前的事件发送给合适的目标控件。

此外UIApplication还会维护一个在本应用打开的window列表(UIWindow实例)，这样他就可以接触到应用中的任何一个UIView对象。

UIApplication实例还会持有一个代理对象，用以处理应用程序的生命周期事件(程序启动和关闭)、系统事件等等(电话、闹钟)。

### UIApplication生命周期

1. `Not running` 未运行，程序没启动。
2. `Inactive` 未激活，程序在前台运行，不过没有接收到事件。
3. `Active` 激活，程序在前台运行而且收到了事件，这也是前台的一个正常的模式。
4. `Background` 后台，程序在后台而且能执行代码。大多数程序进入这个状态后悔在这个状态下停留一会，时间到之后会进入挂起状态(Suspended)。也可以经过请求之后长期处于Background状态。
5. `Suspended` 挂起，程序在后台不能执行代码。系统会自动把程序变成这个状态，而且不会发出通知。当挂起的时候程序还是会停留在内存中，当系统内存低时，会把挂起的程序清除掉。

---

`-(void)applicationSignificantTimeChange:(UIApplication *)application`

当系统事件发生改变时执行