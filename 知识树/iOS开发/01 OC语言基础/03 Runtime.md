## Runtime

OC是一门动态语言，所有的函数调用都是消息发送，在编译期不能知道要调用哪个函数。Runtime就是去解决如何在运行时期找到调用方法的问题。

在编译期间，OC想转译成可执行文件，需要先通过runtime编译为C，C再编译为汇编语言和机器语言。

### objc_msgSend

`[obj foo] -> objc_msgSend(obj, foo)`


```
// 对象
struct objc_object {
	Class isa;
}

// 类
struct objc_class {
	Class isa;
	Class super_class;
	struct objc_method_list *methodLists;
	struct objc_cache *cache;
	...
}

// 方法列表
struct objc_method_list {
	int method_count;
	struct objc_method method_list[1];
	...
}

// 方法
struct objc_method {
	SEL method_name;		// 方法选择器,String
	IMP method_imp;		// 方法实现的指针
	char *method_types;
}
```

1. 首先会通过`obj`的`isa`指针找到对应的`class`;
2. 在`class`的`method list`中找到对应方法`foo`;
3. 如果在`class`中没找到`foo`，就继续往它的`superclass`中查找;
4. 一旦找到`foo`这个函数，就去执行它的实现`IMP`;
5. 把`foo`的`method_name`作为key，`method_imp`作为value保存起来;

### Runtime应用

#### 关联对象

```
// 设置关联对象
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

#### 方法添加替换，KVO实现

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

```
- (void)setName:(NSString *)newName {
	[self willChangeValueForKey:@"name"];
	[super setValue:newName forKey:@"name"];
	[self didChangeValueForKey:@"name"];
}
```

如果手动新建一个名为`NSKVONotifying_A`的类，那么原本的KVO代码会crash。

#### 消息转发(热更新)，解决bug(JSPatch)

JSPatch是利用消息转发机制实现了热更新及代码更新，目前私自接入苹果审核会不通过，可以使用JSPatch团队的平台接入，或者使用React Native。

#### 实现NSCoding的自动归档和解档

原理描述: 用runtime提供的函数遍历Model自身所有属性，并对属性进行encode和decode操作。

核心方法: 在Model的基类中重写方法。

[参考链接](https://www.jianshu.com/p/6ebda3cd8052)

#### 实现字典和模型的自动转换

MJExtension

原理描述: 用runtime提供的函数遍历Model自身所有属性，如果属性在json中有对应的值，则将其赋值。

核心方法: 在NSObject的分类中添加方法。

[参考链接](https://www.jianshu.com/p/6ebda3cd8052)

---

### 关联对象的实现原理

#### 使用场景

1. 为现有的类添加私有变量
2. 为现有的类添加公有属性
3. 为KVO创建关联的观察者

```
void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);

id objc_getAssociatedObject(id object, const void *key);

void objc_removeAssociatedObjects(id object);
```

但是一般不直接使用remove方法，调用会导致所有关联属性被移除。

#### 释放的时机

关联对象有五种关联策略，其中部分的差异点在于是否具有原子性

* `objc_association_assign`
* `objc_association_retain_nonatomic`
* `objc_association_copy_nonatomic`
* `objc_association_retain`
* `objc_association_copy`

正常的释放时机，是在对象被释放的时候调用的，dealloc会触发`_object_remove_assocations`函数移除所有关联对象；

对于弱引用的关联对象，可能会在初始化之后就会被释放，但是关联的对象依旧有值，会保存原对象的地址。后面再调用的时候会造成crash。

#### AssociationsManager

* 系统全局存在单例`AssociationsManager`管理并维护`AssociationsHashMap`；
* 对象的指针及其对应的`ObjectAssociationMap`以键值对的形式存储于`AssociationsHashMap`；每一个对象有一个标记位`has_assoc`指示是否存在关联对象；
* 关联对象`ObjcAssociation`以键值对的形式存储于`ObjectAssociationMap`(键可以是自定义的值，应该可以理解为可以不实现`NSCopying`)