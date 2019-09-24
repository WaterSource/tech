## KVC KVO

### KVC

key value coding

```
// 直接通过Key来取值
- (nullable id)valueForKey:(NSString *)key;                          

// 通过Key来设值
- (void)setValue:(nullable id)value forKey:(NSString *)key;          

// 通过KeyPath来取值
- (nullable id)valueForKeyPath:(NSString *)keyPath;                  

// 通过KeyPath来设值
- (void)setValue:(nullable id)value forKeyPath:(NSString *)keyPath;  
```

### KVO

当你观察一个对象时，一个新的类会动态被创建。这个类继承自该对象的原本的类，并重写了被观察属性的 `setter` 方法。自然，重写的 `setter` 方法会负责在调用原 `setter` 方法之前和之后，通知所有观察对象值的更改。最后把这个对象的 isa 指针 ( isa 指针告诉 Runtime 系统这个对象的类是什么 ) 指向这个新创建的子类，对象就神奇的变成了新创建的子类的实例。

原来，这个中间类，继承自原本的那个类。不仅如此，Apple 还重写了 `-class` 方法，企图欺骗我们这个类没有变，就是原本那个类。

![](https://tva1.sinaimg.cn/large/006y8mN6gy1g75zrliy0ej30jg0bnjsf.jpg)

```
// 添加键值观察
/*
1 观察者，负责处理监听事件的对象
2 观察的属性
3 观察的选项
4 上下文
*/
[self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"Person Name"];
```

```
// 所有的 kvo 监听到事件，都会调用此方法
/*
 1. 观察的属性
 2. 观察的对象
 3. change 属性变化字典（新／旧）
 4. 上下文，与监听的时候传递的一致
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
```

#### 手动触发kvo

```
//@property (nonatomic, strong) NSDate *now;
- (void)viewDidLoad {
   [super viewDidLoad];
   _now = [NSDate date];
   [self addObserver:self forKeyPath:@"now" options:NSKeyValueObservingOptionNew context:nil];
   NSLog(@"1");
   [self willChangeValueForKey:@"now"]; // “手动触发self.now的KVO”，必写。
   NSLog(@"2");
   [self didChangeValueForKey:@"now"]; // “手动触发self.now的KVO”，必写。
   NSLog(@"4");
}
```

