## weak原理

通过Clang将weak编译为C++后可以看到

```
id __weak objc1 = obj;

id __attribute__((objc_ownership(weak))) obj1 = obj;
```

其中`objc_ownership`字面意思是获得对象的所有权，是对象weak的初始化操作。

* weak和strong都是objC的修饰词，都是由runtime初始化并维护的自动计数表结构
* runtime中存在weak表

### 底层结构

`weak_table_t`可以理解为hash表，key是原始对象，value是`weak_entry`结构体；

`weak_entry`则可以理解为所有weak引用的对象的地址数组；

### weak释放为nil的过程

在NSObject调用dealloc的过程中

* 会根据对象地址获取到所有的weak指针地址的数组(weak_entry)
* 遍历数组置为nil
* 在`weak_table_t`中移除`weak_entry`
* 从引用计数表中删除废弃对象的地址为键值的记录 ？？