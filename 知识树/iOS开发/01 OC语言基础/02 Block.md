## Block

### Block语法

Block也是一种OC对象，可以用于赋值、参数传递、放入`collection`中；

`Return_type (^block_name)(parameters)`

* 作为变量

```
returnType (^blockName)(parameterTypes) = ^returnType(parameters) {...};
```

* 作为属性

```
@property(nonatomic, copy) returnType (^blockName)(parameterTypes);
```

* 函数声明中的参数

```
- (void)someMethodWithBlock:(returnType(^)(parameterTypes))blockName;
```

* 作为函数调用中的参数

```
[obj someMethodWithBlock:^returnType (parameters) {...}];
```

* 作为typedef

```
typedef returnType (^TypeName)(parameterTypes);
TypeName blockName = ^returnType(parameters){...};
```

### Block截获变量

1. `基本数据`类型的`局部变量`，只会截获其值
2. `对象`类型的`局部变量`，会连同`所有权修饰符`一起截获
3. `局部静态变量`会以`指针形式`截获
4. `全局变量`和`静态全局变量`，不截获

#### __block

被`__block`修饰的变量会被包装成一个对象;

### Block内存管理

#### _NSConcreteGlobalBlock

全局定义的block，没有捕获外部变量，定义在函数外部；放在数据段；

#### _NSConcreteStackBlock

储存在栈区的block；

截获了局部变量的；

#### _NSConcreteMallocBlock

栈区的block执行copy之后就会移到堆区；存在引用计数，会在引用计数为0的时候才销毁；

1. block作为函数返回值时
2. 将block赋值给__strong指针时
3. block作为系统方法(cocoa API)中的参数时
4. block作为GCD API方法参数时

#### 当Block被copy到堆的时候

1. 会调用block内部的copy函数
2. copy函数内部会调用`_block_object_assign`函数
3. `_block_object_assign`函数会对捕获的变量形成强引用(retain)

#### 当Block从堆中移除时

1. 会调用block内部的`dispose`函数
2. `dispose`函数内部会调用`_block_object_dispose`函数
3. `_block_object_dispose`函数会自动释放引用的变量(release)

### Block循环引用

`__weak`,`__unsafe_unretaind`,`__block`

其中`__block`需要手动将捕获的变量置为nil释放；