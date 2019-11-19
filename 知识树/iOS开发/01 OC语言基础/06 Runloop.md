## Runloop

应用开始运行之后，不做任何操作，应用就像静止了一样，不会有自发的产生动作；如果用户做了操作，就会有对应的响应事件发生，感觉就像是应用一直处于随时待命的状态。这就是runloop的效果。

### Runloop和线程

主线程的runloop默认启动，子线程的runloop需要手动启动；

```
int main(int argc, char *argv[]) {
	@autoreleasepool {
		return UIApplicationMain(argc, argv, nil, NSStringFromClass([appDelegate class]));
	}
}
```

其中`UIApplicationMain`方法内部实现会启动主线程runloop。

这里的`autoreleasepool`主要是为了预防程序中没能正常释放的变量设置，去掉也可以正常运行。

对其他子线程来说，runloop默认是没有启动的，如果你需要更多的线程交互则可以手动配置和启动，如果线程只是去执行一个长时间的已确定的任务则不需要。

---

在任何线程都可以通过这个方法获取到当前线程的run loop。
`NSRunLoop *runloop = [NSRunLoop currentRunLoop];`

NSRunloop类并不是线程安全的，需要跨线程操作的时候需要使用`-(CFRunLoopRef)getCFRunLoop`获取对应的CFRunLoopRef类。

### Input Source和Timer Source

Runloop事件的来源主要就是输入源(Input Source)和定时源(Timer Source)；

其中Input Source可以分为3类

1. `Port-Based Sources`, 系统底层的端口事件，例如CFSocketRef
2. `Custom Input Sources`, 用户手动创建的Source
3. `Cocoa Perform Selector Sources`, Cocoa提供的performSelector系列方法

### Runloop 观察者

Runloop在执行到特定时候会触发的事件

- 准备开启runloop
- 何时处理定时器
- 何时处理输入源
- 何时进入休眠状态
- 何时将要被唤醒(在执行唤醒事件之前)
- 结束runloop

#### Runloop Mode

runloop在某个时刻只能跑在一个Mode下，处理当前Mode中的Source，Timer和Observer。

#### Runloop和autoreleasepool

在主线程runloop中注册了两个Observer

1. 准备开启runloop的时候，注册优先级最高事件，用于初始化pool
2. 即将进入休眠的时候，注册优先级最低的事件，用于释放当前pool

### Runloop的使用场景

1. performSelector相关方法
2. NSTimer相关方法，其中注意需要设置mode为`NSRunLoopCommonModes`,否则会受到UI刷新的影响
3. 需要线程常驻的情况

### 与Runloop相关的坑

* NSTimer和UIScrollView

`NSRunLoopCommonModes`这个mode是一个mode的集合，注册到这个mode下之后，无论当前runloop运行在哪个mode，事件都可以执行

---

* 子线程中的performSelector

求以下打印结果

```
// 等效于串行队列
dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
dispatch_async(queue, ^{
    NSLog(@"1");
    [self performSelector:@selector(test) withObject:nil afterDelay:0];
    NSLog(@"3");
});

- (void)test{
    NSLog(@"2");
}
```
答：

打印 1,3

`performSelector: withObject: afterDelay:` 是基于`timer`的定时器, 定时器又是基于`runloop`实现的; 任务2在子线程中,子线程默认 `runloop`是不开启的,所以不执行2

```
// 增加以下修改，即可打印 132，猜测是在runloop周期结束前处理未处理的事件
dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
dispatch_async(queue, ^{
	NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    NSLog(@"1");
    [self performSelector:@selector(test) withObject:nil afterDelay:0];
    NSLog(@"3");
    [runloop run];
});
```