## GCD 多线程

### GCD

#### 优势

- 用于多核的并行运算
- 会自动利用更多的CPU内核(比如双核、四核)
- 会自动管理线程的生命周期
- 不需要编写线程管理代码

#### 任务和队列

dispatch: 派遣/调度

queue: 队列

执行任务有两种方式，“同步执行”和“异步执行”。主要区别在于是否等待队列的任务执行结束，是否具备开启新线程的能力。

- 同步执行(sync)
	- 再添加的任务执行结束之前，会一直等待，直到队列里面的任务完成之后再继续执行；
	- 只能在当前线程中执行任务，不具备开启新线程的能力；

- 异步执行(async)
	- 不会做任何等待，可以继续执行任务；
	- 可以在新线程中执行任务，具备开新线程的能力；
	
在GCD有两种队列，“串行队列”和“并发队列”。主要区别在于执行顺序不同，开启线程数不同。

- 串行队列(Serial)
	- 只开启一个线程，一个任务执行完毕后，再执行下一个任务；
- 并发队列(Concurrent)
	- 可以开启多个线程，并且同时执行任务;
	- 并发队列的并发功能只有在异步(dispatch_async)方法下才有效；

#### 创建队列

`dispatch_queue_create`方法来创建队列，该方法涉及两个参数；

- 第一个参数表示队列的唯一标识符，可为空；
- 第二个参数识别串行队列还是并发队列；

```
// 串行队列的创建方法
dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", nil);

// 并发队列的创建方法
dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
```

`主队列 dispatch_get_main_queue()`是特殊的串行队列；

`全局并发队列 dispatch_get_global_queue`首个参数为队列优先级，一般使用`DISPATCH_QUEUE_PRIORITY_DEFAULT`；第二个参数暂时没用？

总结下来会存在6种任务和队列的组合方式

##### 在主线程环境下，这6种组合的情况

|区别|并发队列|串行队列|主队列|
|---|---|---|---|
|同步执行(sync)| 没有开启新线程，串行执行任务 | 没有开启新线程，串行执行任务 | 死锁卡住不执行 |
|异步执行(async)| 有开启新线程，并发执行任务 | 有开启新线程(1条)，串行执行任务 | 没有开启新线程，串行执行任务 |

##### 在并发队列中

|区别|【异步执行+并发队列】嵌套【同一个并发队列】|【同步执行+并发队列】嵌套【同一个并发队列】|
|---|---|---|
|同步执行(sync)| 没有开启新线程，串行执行任务 | 没有开启新线程，串行执行任务 |
|异步执行(async)| 有开启新线程，并发执行任务 | 有开启新线程，并发执行任务 |

##### 在串行队列中

|区别|【异步执行+串行队列】嵌套【同一个串行队列】|【同步执行+串行队列】嵌套【同一个串行队列】|
|---|---|---|
|同步执行(sync)| 死锁 | 死锁 |
|异步执行(async)| 有开启新线程(1条)，串行执行任务 | 有开启新线程(1条)，串行执行任务 |

#### 举例理解

假设现在有 5 个人要穿过一道门禁，这道门禁总共有 10 个入口，管理员可以决定同一时间打开几个入口，可以决定同一时间让一个人单独通过还是多个人一起通过。不过默认情况下，管理员只开启一个入口，且一个通道一次只能通过一个人。

- 这个故事里，人好比是 **任务**，管理员好比是 **系统**，入口则代表 **线程**。

	- 5 个人表示有 5 个任务，10 个入口代表 10 条线程。
	- **串行队列** 好比是 5 个人排成一支长队。
	- **并发队列** 好比是 5 个人排成多支队伍，比如 2 队，或者 3 队。
	- **同步任务** 好比是管理员只开启了一个入口（当前线程）。
	- **异步任务** 好比是管理员同时开启了多个入口（当前线程 + 新开的线程）。

- **『异步执行 + 并发队列』** 可以理解为：现在管理员开启了多个入口（比如 3 个入口），5 个人排成了多支队伍（比如 3 支队伍），这样这 5 个人就可以 3 个人同时一起穿过门禁了。


- **『同步执行 + 并发队列』** 可以理解为：现在管理员只开启了 1 个入口，5  个人排成了多支队伍。虽然这 5 个人排成了多支队伍，但是只开了 1 个入口啊，这 5 个人虽然都想快点过去，但是 1 个入口一次只能过 1 个人，所以大家就只好一个接一个走过去了，表现的结果就是：顺次通过入口。

### GCD的其他方法

- 栅栏方法 `dispatch_barrier_async`

![](https://tva1.sinaimg.cn/large/006y8mN6gy1g79lyikk1nj30yg0hot9x.jpg)

- 延时执行方法 `dispatch_after`

```
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
	// 2.0 秒后异步追加任务代码到主队列，并开始执行
	NSLog(@"after---%@",[NSThread currentThread]);  // 打印当前线程
});
```

需要注意的是，`dispatch_after`方法是在指定时间之后追加到主队列中，时间并非绝对准确；

- `dispatch_once`

- 快速迭代方法 `dispatch_apply`

```
dispatch_apply(6, queue, ^(size_t index) {
	NSLog(@"%zd---%@",index, [NSThread currentThread]);
});
```
在串行队列中使用，那么就和`for`循环一样，按顺序同步执行；在并发队列中执行，可以在多个线程中同时遍历；

无论什么队列，都会等待全部任务执行完成；

- 队列组 

`dispatch_group``dispatch_group_notify``dispatch_group_wait`

`dispatch_group_async``dispatch_group_enter``dispatch_group_leave`

- 信号量 `dispatch_semaphore`

`dispatch_semaphore_create(0)`创建一个 Semaphore 并初始化信号的总量

`dispatch_semaphore_signal(semaphore)`发送一个信号，让信号总量加 1

`dispatch_semaphore_wait(semaphore)`可以使总信号量减 1，信号总量小于 0 时就会一直等待（阻塞所在线程），否则就可以正常执行。

使异步线程同步；

为线程加锁；

```
/**
 * 线程安全：使用 semaphore 加锁
 * 初始化火车票数量、卖票窗口（线程安全）、并开始卖票
 */
- (void)initTicketStatusSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    semaphoreLock = dispatch_semaphore_create(1);
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
}

/**
 * 售卖火车票（线程安全）
 */
- (void)saleTicketSafe {
    while (1) {
        // 相当于加锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        
        if (self.ticketSurplusCount > 0) {  // 如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { // 如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            
            // 相当于解锁
            dispatch_semaphore_signal(semaphoreLock);
            break;
        }
        
        // 相当于解锁
        dispatch_semaphore_signal(semaphoreLock);
    }
}

```

### 多线程

![](https://tva1.sinaimg.cn/large/006y8mN6gy1g7aepqgdvcj30yg0h6goq.jpg)

#### 进程

进程是计算机中的程序关于某数据集合上的一次运行活动，是系统进行资源活动分配和调度的基本单位，是操作系统结构的基础，每一个进程都有自己独立的虚拟内存空间。

简单来说，进程是指在系统中正在运行的一个应用程序，每一个程序都是一个进程，并且进程之间是独立的，每个进程都运行在其专用且受保护的内存空间内。

#### 线程

线程是程序执行流的最小单位，线程是程序中一个单一的顺序控制流程。是进程内一个相对独立的、可调度的执行单元，是系统独立调度和分派CPU的基本单元，是运行中程序的调度单位。

简单来说，1个进程要想执行任务，必须得有线程。线程中任务的执行是串行的；一个进程中至少包含一条线程，即主线程。创建线程的目的就是为了开启一条新的执行路径，运行制定的代码，与主线程中的代码同时运行。

#### NSThread

NSThread创建线程有3种方法

```
// NSThread.h

/*
@param selector	执行的方法
@param target	提供selector的对象
@param argument	传递给selector的参数
*/
+ (void)detachNewThreadSelector:(SEL)selector toTarget:(id)target withObject:(nullable id)argument;

+ (void)detachNewThreadWithBlock:(void (^)(void))block;

/*
@param selector	执行的方法
@param target	提供selector的对象
@param argument	传递给selector的参数
*/
- (instancetype)initWithTarget:(id)target selector:(SEL)selector object:(nullable id)argument;

- (instancetype)initWithBlock:(void (^)(void))block;

- (void)start;
- (void)cancel;

// 强行终止
+ (void)exit;
```

```
// NSObject+NSThreadPerformAdditions

/*
@param selector	执行的方法
@param arg		传递给selector的参数
*/
- (void)performSelectorInBackground:(SEL)aSelector withObject:(nullable id)arg;
```

线程的优先级，取值范围从0.0-1.0，默认优先级为0.5，最高为1.0
`thread.threadPriority`

线程的堆大小，线程执行前堆栈大小为512k，线程完成后堆栈大小为0k;线程执行完毕后，由于空间被释放，不能再次启动
`thread.stackSize`

![](https://tva1.sinaimg.cn/large/006y8mN6gy1g7akfkzendj30z00astad.jpg)

##### 线程间通信

```
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(nullable id)arg waitUntilDone:(BOOL)wait;

- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait;
```

#### NSOperation

NSOperation是基于GCD的面向对象封装。NSOperation是一个抽象类，不能直接使用，应该使用它的子类`NSInvocationOperation`,`NSBlockOperation`和自定义继承子类。

`NSOperation`一般使用是配合操作队列`NSOperationQueue`进行的，一旦加入到队列中就会自动**异步执行**；如果没有添加到队列，直接使用`start`方法，则会在当前线程执行。

##### NSInvocationOperation

```
// 1. 创建
NSOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(testAction:) object:@"Test"];
// 2. start,直接在当前线程执行
[op1 start];

- (void)testAction:(id)object {
	// object = @"Test"
	// Main Thread
}
```

```
// 1. 创建
NSOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(testAction:) object:@"Test"];

// 2. 放到队列中
NSOperationQueue *queue = [[NSOperationQueue alloc] init];
// 加入队列的时候，会自动异步执行任务
[queue addOperation:op2];
```

##### NSBlockOperation

```
NSOperationQueue *queue = [[NSOperationQueue alloc] init];
// 限制线程数为1，是否就是串行了？
queue.maxConcurrentOperationCount = 1;

NSOperationQueue *queue = [NSOperationQueue mainQueue];

NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
	// ...
}];

[queue addOperation:op];
```

```
NSOperationQueue *queue = [[NSOperationQueue alloc] init];
[queue addOperationWithBlock:^{
	// ...
}];
```

##### 其他高级封装

- 最大并发数

`operationQueue.maxConcurrentOperationCOunt = 2;`

- 线程挂起

暂停队列操作，已经在执行的任务不受影响

`operationQueue.suspended = YES;`

- 取消队列操作

取消队列的操作，已经在执行的任务无法取消

`[operationQueue cancelAllOperation];`

- 依赖关系

```
NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
	NSLog(@"1.下载一个小说压缩包,%@",[NSThread currentThread]);
}];

NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
	NSLog(@"2.解压缩，删除压缩包,%@",[NSThread currentThread]);
}];

NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
	NSLog(@"3.更新UI,%@",[NSThread currentThread]);
}];

// 指定任务之间的依赖关系 --依赖关系可以跨队列(可以再子线程下载，在主线程更新UI)
  [op2 addDependency:op1];
  [op3 addDependency:op2];
//  [op1 addDependency:op3];  一定不能出现循环依赖

// waitUntilFinished  类似GCD中的调度组的通知
// NO不等待，直接执行输出come here
// YES等待任务执行完再执行输出come here
[self.opQueue addOperations:@[op1,op2] waitUntilFinished:YES];

// 在主线程更新UI
[[NSOperationQueue mainQueue] addOperation:op3];
NSLog(@"come here");
```

### 锁

多个线程访问同一块资源读写，随意访问产生数据错乱引发的数据问题；

- os_unfair_lock
- dispatch_semaphore
- dispatch_mutex
- dispatch_queue 串行
- NSLock
- @synchronized 性能最差



