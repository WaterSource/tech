## Swift的内存分配和方法调度

[参考链接](https://blog.csdn.net/hello_hwc/article/details/53147910)

[Swift开源地址](https://github.com/apple/swift)

### 开篇简介

从开源的地址可以看出

* Swift是由C++写的
* Swift的核心Library是用Swift自身写的

对于C++来说，内存区间是

* 堆区
* 栈区
* 代码区
* 全局静态区

对于Swift来说，和C++的类似也存在存储代码和全局变量的区间

* Stack (栈)，存储值类型的临时变量，函数调用栈，引用类型的临时变量指针
* Heap (堆)，存储引用类型的实例

### 栈

在栈上分配和释放内存代价都很小，因为栈是通过移动栈顶的指针来完成内存的创建和释放。

但是栈的内存空间有限，在编译期就已经确定了栈的空间大小。

举个简单例子: 当一个递归函数，陷入了死循环，那么最后函数调用栈会溢出[Stack Overflow]

### 堆

在堆上可以动态的按需分配内存，每次在堆上分配内存的时候，需要查找堆上能提供相应大小的位置，然后返回对应位置，标记指定位置大小内存被占用。

在堆上能够动态分配所需大小的内存，但是由于每次要查找，并且要考虑到多线程之间的线程安全问题，所以堆相比于栈性能会低很多。

### 内存对齐

和C/C++/OC类似，Swift也有Memory Alignment的概念。

```
struct S {
	var x: Int64
	var y: Int32
}

struct S_reverse {
	var y: Int32
	var x: Int64
}
```

然后用MemoryLayout获取两个结构体的大小

```
let sSize = MemoryLayout<S>.size // 12
let sReverseSize = MemoryLayout<SReverse>.size // 16
```

只是调整声明的顺序就会改变内存大小，这就是内存对齐。

内存对齐的原因是

```
现代CPU每次读数据的时候，都是读取一个word (32位处理器上是4个字节，64位处理器上是8个字节)

8bit = 1byte
```

内存对齐的优点很多

* 保证对一个成员的访问在一个`Transition`中，提高了访问速度，同时还能保证一次操作的原子性。

### 自动引用计数(ARC)

* 值类型，在赋值的时候会进行值拷贝
* 引用类型，在赋值的时候会进行引用拷贝

--

### 方法调度

Swift的方法调度分为两种

* 静态调度 static dispatch, 静态调度在执行的时候，会直接跳到方法的实现，静态调度可以进行inline和其他编译期的优化。
* 动态调度 dynamic dispatch, 动态调度在执行的时候会根据运行时(Runtime), 采用tabble的方式，找到方法的执行体，然后执行。动态调度也就没有办法像静态那样，进行编译期优化。

#### Struct

对于Struct来说，方法调度是静态的。

Static Dispatch, 在编译期就能够知道方法的执行体，所以在runtime的时候也就不需要额外的空间来存储方法信息。

编译后，方法的调用就直接将变量的地址传入，存在代码区。还可以开启编译器优化，优化为Inline。`Inline??`

#### Class

Class是 Dynamic Dispatch的，所以在添加方法之后，Class本身在栈上分配的仍然是一个word。在堆上会有额外的word来存储Class的Type信息，在Class的Type信息中，存储着V-table。根据V-table可以找到对应的方法执行体。

![](https://tva1.sinaimg.cn/large/0082zybpgy1gc0xh7wab7j30q60me3zu.jpg)

#### 继承

因为Class的实体会存储额外的Type信息，所以子类只需要存储子类的Type信息。

#### 协议

Swift中协议类型会采用如下的内存模型 - Existential Container

![](https://tva1.sinaimg.cn/large/0082zybpgy1gc0xofu91pj30ha0hgt98.jpg)

* 前三个word，value buffer，保存Inline的值，如果word数大于3，则会采用指针的方式在堆上分配对应大小的内存
* 第四个word，VWT，每个类型都会有一个这样的表结构，存储生命周期的几个函数，创建、释放、拷贝等
* 第五个word，PWT，用来存储协议的函数

#### 泛型

泛型使得代码支持了静态多态。

在内存中并不采用协议的样式，但是原理类似。

* VWT和PWT作为隐形参数，传递到泛型方法中
* 临时变量仍然按照Valuebuffer的逻辑，分配3个word，超过3个就会在堆上开辟内存存储