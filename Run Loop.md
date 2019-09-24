## Run Loop

### 简介

应用开始运行之后，不做任何操作，应用就像静止了一样，不会有自发的产生动作；如果用户做了操作，就会有对应的响应事件发生，感觉就像是应用一直处于随时待命的状态。这就是run loop的效果。

### 线程与run loop

#### 主线程的run loop是默认启动的

```
int main(int argc, char *argv[]) {
	@autoreleasepool {
		return UIApplicationMain(argc, argv, nil, NSStringFromClass([appDelegate class]));
	}
}
```

通过这个方法就为主线程(main thread)设置了`NSRunLoop`对象.

对其他线程来说，run loop默认是没有启动的，如果你需要更多的线程交互则可以手动配置和启动，如果线程只是去执行一个长时间的已确定的任务则不需要。

在任何线程都可以通过这个方法获取到当前线程的run loop。
`NSRunLoop *runloop = [NSRunLoop currentRunLoop];`

NSRunloop类并不是线程安全的，需要跨线程操作的时候需要使用`-(CFRunLoopRef)getCFRunLoop`获取对应的CFRunLoopRef类。

#### run loop同时负责autorelease pool的创建和释放

run loop每当一个运行循环结束的时候，就会释放一次autorelease pool，同时pool中所有自动释放类型变量都会被释放掉。

### run loop 相关知识点

#### 输入事件来源

主要分为输入源(input source)和定时源(timer source)。

##### 基于端口的输入源

基于端口的输入源由内核自动发送，Cocoa和Core Foundation内置支持使用端口相关的对象和函数来创建基于端口的源。

```
// 这个例子展示了如何创建一个基于端口的数据源，添加到run loop并启动

void createPortSource() {
	CFMessagePortRef port = CFMessagePortCreateLocal(kCFAllocatorDefault, CFSTR("com.someport"), myCallbackFunc, NULL, NULL);
	
	CFRunLoopSourceRef source = CFMessagePortCreateRunLoopSource(kCFAllocatorDefault, port, 0);
	
	CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
	
	while (pageStillLoading) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		CFRunLoopRun();
		[pool release];
	}
	
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
	CFRelease(source);
}
```

##### 自定义输入源

自定义的输入源需要人工从其他线程发送。

```
void createCustomSource() {
	CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
	
	CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
	
	CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
	
	while (pageStillLoading) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		CFRunLoopRun();
		[pool release];
	}
	
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
	CFRelease(source);
}
```

##### Cocoa上的Selector源

除了基于端口的源，Cocoa定义了自定义输入源，允许你在任何线程执行selector方法。当在其他线程上面执行selector时，目标线程需要有一个活动的run loop。对于你创建的线程，这意味着线程在你显示启动run loop之前是不会执行selector方法的，会一直休眠状态。

```
// NSObject类提供了类似如下的selector方法
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(nullable id)arg waitUntilDone:(BOOL)wait modes:(nullable NSArray<NSString *> *)array;
```

##### 定时源

```
NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(action:)
                                                userInfo:nil
                                                 repeats:YES];
                                                 
[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
```

#### RunLoop观察者

可以在run loop本身运行到特定时候触发。

- run loop入口
- 何时处理一个定时器
- 何时处理一个输入源
- 何时进入睡眠状态
- 何时被唤醒，在唤醒之前要处理的事件
- run loop终止

```
/* Run Loop Observer Activities */
typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
   kCFRunLoopEntry = (1UL << 0), // 进入runloop的时候
   kCFRunLoopBeforeTimers = (1UL << 1),// 执行timer前
   kCFRunLoopBeforeSources = (1UL << 2), // 执行事件源前
   kCFRunLoopBeforeWaiting = (1UL << 5),//休眠前
   kCFRunLoopAfterWaiting = (1UL << 6),//休眠后
   kCFRunLoopExit = (1UL << 7),// 退出
   kCFRunLoopAllActivities = 0x0FFFFFFFU
};

/*
@param allocator 对象内存分配器，一般使用默认的分配器kCFAllocatorDefault。或者NULL
@param activities 配置观察者监听run loop的那种运行状态。
@param repeats 标识观察者只监听一次还是每次run loop运行时都监听。
@param order 观察者优先级，当有多个观察者监听同一个运行状态时，会根据该优先级判断，0为最高优先级。
@param callout 观察者的回调函数，在Core Foundation框架中用CFRunLoopObserverCallBack重定义了回调函数的闭包
@param context 观察者的上下文。(类似KVO传递的content，可以传递信息)

CFRunLoopObserverRef CFRunLoopObserverCreate(CFAllocatorRef allocator, CFOptionFlags activities, Boolean repeats, CFIndex order, CFRunLoopObserverCallBack callout, CFRunLoopObserverContext *context);

CFRunLoopObserverRef CFRunLoopObserverCreateWithHandler(CFAllocatorRef allocator, CFOptionFlags activities, Boolean repeats, CFIndex order, void (^block)( CFRunLoopObserverRef observer, CFRunLoopActivity activity) );
*/
```

```
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
	PerformanceMonitor *moniotr = (__bridge PerformanceMonitor *)info;
	moniotr->activity = activity;
	
	dispatch_semaphore_t semaphore = moniotr->semaphore;
	dispatch_semaphore_signal(semaphore);
}

- (void)addObserverToCurrentRunLoop {
	NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
	
	CFRunLoopObserverContext context = {0, (__bridge void*)self, NULL, NULL};
	
	// kCFRunLoopBeforeTimer表示选择监听定时器触发前处理事件，YES表示循环监听
	CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, 
                    				                          kCFRunLoopAllActivities, 
                    				                          YES, 
                    				                          0, 
                    				                          &myRunLoopObserver, 
                    				                          &context);
	
	if (observer) {
		CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
		CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
	}
}
```

```
CFRunLoopObserverRef  observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault,
																	kCFRunLoopAllActivities,
																	true,
																	0,
																	^(CFRunLoopObserverRef observer, CFRunLoopActivity activitys) {
																		self->activity = activitys;
																		dispatch_semaphore_t semaphores = self->semaphore;
																		dispatch_semaphore_signal(semaphores);
																	});
// 将观察者添加到主线程runloop的common模式下的观察中
CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);     
```

##### 利用runloop记录卡顿

```
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    MyClass *object = (__bridge MyClass*)info;
    
    // 记录状态值
    object->activity = activity;
    
    // 发送信号
    dispatch_semaphore_t semaphore = moniotr->semaphore;
    dispatch_semaphore_signal(semaphore);
}

- (void)registerObserver {
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                            kCFRunLoopAllActivities,
                                                            YES,
                                                            0,
                                                            &runLoopObserverCallBack,
                                                            &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    // 创建信号
    semaphore = dispatch_semaphore_create(0);
    
    // 在子线程监控时长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            // 假定连续5次超时50ms认为卡顿(当然也包含了单次超时250ms)
            long st = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
            if (st != 0) {
                if (activity==kCFRunLoopBeforeSources || activity==kCFRunLoopAfterWaiting) {
                    if (++timeoutCount < 5)
                        continue;
                    
                    NSLog(@"好像有点儿卡哦");
                }
            }
            timeoutCount = 0;
        }
    });
}
```

#### run loop的事件队列

每次运行run loop，线程的run loop会自动处理之前未处理的消息，并且通知相关的观察者；

顺序如下:

1. 通知run loop已经启动
2. 通知定时器即将要开始
3. 通知有非基于端口的源即将启动
4. 启动已经准备好的非基于端口的源
5. 如果基于端口的源已经准备好，并且处于等待状态，立即启动，并进入步骤9；
6. 通知观察者线程进入休眠
7. 将线程置于休眠到任一下面的事件发生
	1. 某一事件到达基于端口的源
	2. 定时器启动
	3. run loop设置的时间已经超时
	4. run loop被显示唤醒
8. 通知观察者线程将被唤醒
9. 处理未处理的事件
	1. 如果用户定义的定时器启动，处理定时器事件并重启run loop。进入步骤2；
	2. 如果输入源启动，传递相应的消息；
	3. 如果run loop被显式唤醒而且事件还没超时，重启run loop。进入步骤2；
10. 通知观察者run loop结束

### 什么时候使用run loop

对于辅助线程，需要判断run loop是否必须。如果是一个预先定义的长时间运行的任务，应该避免启动run loop。Run loop应该在要和线程有更多交互时才需要：

1. 使用端口或者自定义输入源来和其他线程通信
2. 使用线程的定时器
3. Cocoa中任何performSelector...的方法
4. 使线程周期性工作

### 例题

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