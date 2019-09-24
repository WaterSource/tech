## RunTime

### 介绍

64位系统使用的是对应`Objective-C 2.0`的`modern`版本，早期32位系统使用的是对应`Objective-C 1`的`legacy`版本。区别在于，更改一个类的实例变量的布局时，早期版本需要重新编译它的子类，现行版本不需要。

`OC`转译成可执行文件，需要先通过`runtime`编译为`C`，`C`再编译为汇编语言和机器语言。

### 消息传递

#### 类对象 objc_class

`typedef struct objc_class *Class;`

```
struct objc_class {
	// isa指针
	Class _Nonnull isa OBJC_ISA_AVAILABILITY;
	
#if !__OBJC2__
	// 父类的指针
	Class _Nullable super_class;
	// 类的名字
	const char * _Nonnull name;
	long info;
	// 实例大小
	long instance_size;
	// 实例变量列表
	struct objc_ivar_list * _Nullable ivars;
	// 方法列表
	struct objc_method_list * _Nullable methodLists;
	// 缓存
	struct objc_cache * _Nonnull cache;
	// 遵守的协议列表
	struct objc_protocol_list * _Nullable protocols;
#endif
} OBJC2_UNAVAILABLE;
```

#### 实例 objc_object

`typedef  struct objc_object *id;`

```
struct objc_object {
	Class isa;
}
```

#### 元类 Meta Class

所有的类自身也是一个对象，我们可以向这个对象发送消息(即调用类方法)。


#### Method (objc_method)

`typedef struct objc_method *Method;`

```
struct objc_method {
	// 方法名
	SEL method_name;
	// 方法类型
	char *method_types;
	// 方法实现
	IMP method_imp;
}
```

#### SEL (objc_selector)

`typedef struct objc_selector *SEL;`

`selector`是方法选择器，可以理解为方法的ID，而这个ID的数据结构是`SEL`。

`@property SEL selector;`

同一个类，`selector`不能重复;不同的类，`selector`可以重复；

因为以上特性，OC方法没有重载(函数名相同，参数不同的方法);


#### IMP

指向一个方法实现的指针。

`typedef id (*IMP)(id, SEL, ...)`

#### 类缓存 (objc_cache)

为了提高方法检索效率，以及一个理论：你在类上调用一个消息，你可能以后再次调用该消息。

所以类实现一个缓存，每当你搜索一个类的分派表并找到对应的选择器，这个选择器就会被放入类缓存中。

#### Category (objc_category)

```
struct category_t {
	// 指的是class_name,而不是category_name
	const char *name;
	// 要扩展的类对象，编译期间不会定义，在运行时通过runtime找到对应的类对象
	classref_t cls;
	// 增加的实例方法列表
	struct method_list_t *instanceMethods;
	// 增加的类方法列表
	struct method_list_t *instanceMethods;
	// 实现的协议列表
	struct protocol_list_t *protocols;
	// 用runtime动态增加的属性列表
	struct protocol_list_t *instanceProperties;
}
```

### 消息转发

### runtime应用

#### 关联对象

```
// 关联对象
void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)

// 获取关联的对象
id objc_getAssociatedObbject(id object, const void *key)

// 移除所有的关联对象
void objc_removeAssociatedObjects(id object)
```

```
内存管理策略
typedef OBJC_ENUM(uintptr_t, objc_AssociationPolicy) {

	/**< Specifies a weak reference to the associated object. */
	// 等效为assign, unsafe_unretained
    OBJC_ASSOCIATION_ASSIGN = 0,
    
    /**< Specifies a strong reference to the associated object. The association is not made atomically. */
    // 等效为 (nonatomic, strong)
    OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, 
    
    /**< Specifies that the associated object is copied. The association is not made atomically. */
    // 等效为 (nonatomic, copy)
    OBJC_ASSOCIATION_COPY_NONATOMIC = 3,   
    
    /**< Specifies a strong reference to the associated object. The association is made atomically. */
    // 等效为 (atomic, strong)
    OBJC_ASSOCIATION_RETAIN = 01401,       
    
    /**< Specifies that the associated object is copied. The association is made atomically. */
    // 等效为 (atomic, copy)
    OBJC_ASSOCIATION_COPY = 01403          
};

```

#### 方法添加替换，kvo实现

##### 添加

```
// cls: 被添加方法的类
// name: 添加方法的名称的SEL
// imp: 方法的实现，至少需要两个参数self和_cmd
// 类型编码
class_addMethod(Class _Nullable __unsafe_unretained cls, SEL _Nonnull name, IMP _Nonnull imp, const char * _Nullable types)
```

##### 替换

```
+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		// case1: 替换实例方法
       Class selfClass = [self class];
       // case2: 替换类方法
       Class selfClass = object_getClass([self class]);
       
       // 原方法的SEL和Method
       SEL originalSelector = @selector(viewDidLoad);
       Method originalMethod = class_getInstanceMethod(selfClass,originalSelector);
       
       // 替换方法的SEL和Method
       SEL swizzledSelector = @selector(swizzle_viewDidLoad);
       Method swizzledMethod = class_getInstanceMethod(selfClass,swizzledSelector);
        
       // 尝试给原方法增加实现，避免原方法没有实现的情况
       BOOL didAddMethod = class_addMethod(selfClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
       if (didAddMethod) {
       	// 添加成功，将原方法的实现替换到交换方法的实现
	    	class_replaceMethod(selfClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
       } else {
       	// 添加失败，说明原方法已经有实现，交换两个方法的实现
          method_exchangeImplementations(originalMethod, swizzledMethod);
       }
    });
}
```

##### kvo实现

系统在观察对象`A`时，会动态创建一个名为`NSKVONotifying_A`的新类，继承自对象`A`，并且重写观察属性的`setter`方法，在执行原本的`setter`操作前后分别抛出通知。

如果手动新建一个名为`NSKVONotifying_A`的类，那么原本的KVO代码会crash。

#### 消息转发(热更新) 解决bug(JSPatch)

JSPatch是利用消息转发机制实现了热更新及代码更新，目前私自接入苹果审核会不通过，可以使用JSPatch团队的平台接入，或者使用React Native。

#### 实现NSCoding的自动归档和自动解档

略

#### 实现字典和模型的自动转换(MJExtension)

略

参考链接 https://www.jianshu.com/p/6ebda3cd8052