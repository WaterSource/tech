## KVC KVO

### KVC

无论是`OC`还是`Swift`，KVC的定义都是对`NSObject`的扩展来实现的(其中`OC`中存在显式的`NSKeyValueCoding`类别名，`Swift`不需要);

key value coding，最重要的是以下4个方法;

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

`NSKeyValueCoding`中其他的一些方法

```
// 默认返回YES，表示如果没有找到Set<Key>方法的话，会按照_key，_iskey，key，iskey的顺序搜索成员，设置成NO就不这样搜索
+ (BOOL)accessInstanceVariablesDirectly;

// KVC提供属性值正确性验证的API，它可以用来检查set的值是否正确、为不正确的值做一个替换值或者拒绝设置新值并返回错误原因。
- (BOOL)validateValue:(inout id __nullable * __nonnull)ioValue forKey:(NSString *)inKey error:(out NSError **)outError;

// 这是集合操作的API，里面还有一系列这样的API，如果属性是一个NSMutableArray，那么可以用这个方法来返回。
- (NSMutableArray *)mutableArrayValueForKey:(NSString *)key;

// 如果Key不存在，且没有KVC无法搜索到任何和Key有关的字段或者属性，则会调用这个方法，默认是抛出异常。
- (nullable id)valueForUndefinedKey:(NSString *)key;

// 和上一个方法一样，但这个方法是设值。
- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key;

// 如果你在SetValue方法时面给Value传nil，则会调用这个方法
- (void)setNilValueForKey:(NSString *)key;

// 输入一组key,返回该组key对应的Value，再转成字典返回，用于将Model转到字典。
- (NSDictionary<NSString *, id> *)dictionaryWithValuesForKeys:(NSArray<NSString *> *)keys;
```

#### KVC的底层实现

当一个对象调用`setValue`方法时，方法内部会做以下操作

* 检查是否存在相应key的set方法，如果存在，就调用set方法；
* 如果set方法不存在，就会查找和key相同名称且带下划线的成员属性，如果有，则直接给成员属性赋值；
* 如果没有找到_key，就会查找相同名称的属性key，如果有就直接赋值；【这个描述不准确，检查参考链接】
* 如果还没有找到，则调用`valueForUndefinedKey:`和`setValue: forUndefinedKey:`；

#### 关于KVC的一切

[参考链接](https://www.jianshu.com/p/45cbd324ea65)

#### KVC的使用场景

* 动态取值和赋值
* 访问私有变量
* Model和字典转换
* 用`setValue:forKeyPath:`修改控件的内部属性
* 操作集合
* 高阶消息传递 

```
// 全员首字母大写
NSArray *tmp1 = [arr valueForKey:@"capitalizedString"];
// 全员首字母大写后的长度
NSArray *tmp2 = [arr valueForKeyPath:@"capitalizedString.length"];
```

* 函数操作集合

```
@interface xx {
	@property CGFloat price;
}

[arr valueForKeyPath:@"@sum.price"]
@"@avg.price"
@"@count"
@"@max.price"
@"@min.price"
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

