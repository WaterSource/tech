## Swift

### 基础问答

#### 0. 实现一个 min 函数

```
func myMin<T: Comparable>(a: T, b: T) -> T {
	return a < b ? a : b
}
```

#### 1. class 和 struct 的区别

`class`是引用类型，在被赋值的时候不会被拷贝，增加引用计数；

`struct`是值类型，不可以被继承，通过被复制的方式在代码中传递，不使用引用计数；

#### 2. 不通过继承，代码复用的方式有哪些

可以通过 `全局函数`、`扩展extension` 和 `协议protocol` 实现代码复用；

`extension`可以

* 增加计算型属性
* 定义 实例方法 和 类方法
* 提供新的构造器
* 定义下标
* 定义和使用心得嵌套类型 (嵌套类型:在作用域内定义新的类、结构体、枚举)
* 实现某个协议

`protocol`可以

* 规定实现协议的类实现特定的方法、属性；

#### 3. Set 独有的方法有哪些

集合类型，存放不重复的元素；

特有方法可以归纳为数学领域内的并集、交集等；

#### 4. map、fliter、 reduce 的作用

`map`是遍历数组元素，每个元素执行闭包内的方法返回一个新的数组

```
[1,2,3].map{"\($0)"}
["1","2","3"]
```

`fliter`是过滤元素，返回满足条件的元素，组成新的数组

```
[1,2,3,4].fliter{$0%2==0}
[2,4]
```

`reduce`是合并计算
```
[1,2,3].reduce("初始值"){$0 + "\($1)"}
"初始值123"
```

#### 5. map、 flatmap的区别

`flatmap`有两种功能

```
func flatMap<T>(_ transform: (Element) -> T)) -> [T]
```

* 数组元素解包

```
["1", "@", "2"].flatMap{Int($0)}
[1, 2]
```

* 数组降维

```
[[1],[2,3],[4,5]].flatMap{$0}
[1,2,3,4,5]
```

#### 6. 什么是 copy on write

写时复制，如果值类型对象很大，作为参数传递时拷贝的代价太大，就可以使用写时复制技术；

系统中`array`、`dictionary`、`set`中已经实现了写时复制；

如果全局只有唯一引用，在赋值时会原地变更；否则需要先拷贝，再对值进行变化；

```
final class Ref<T> {
    var value: T
    init(value: T) {
        self.value = value
    }
}

struct Box<T> {
    private var ref: Ref<T>
    init(value: T) {
        ref = Ref(value: value)
    }
 
    var value: T {
        get { return ref.value }
        set {
        		// 关键方法，判断当前引用是否唯一
            guard isKnownUniquelyReferenced(&ref) else {
                ref = Ref(value: newValue)
                return
            }
            ref.value = newValue
        }
    }
}

```

#### 7. 声明一个只能被类 conform 的 protocol

```
protocol ClassOnlyProtocol: class, OtherProtocol {
	// 只看到有对类的限制，没有找到对结构体和枚举的写法
}
```

#### 8. defer 的使用场景

`defer`的代码会在当前作用域结束前调用；

```
func action() {
	defer {
		print("后加入的先执行")
	}
	if (true) {
		defer {
			print("后加入的先执行")
		}
	}
	
	print("action end")
}
```

#### 9. String 与 NSString 的关系和区别

`swift`中的`String`是【结构体】【值类型】，`NSString`是【类】【引用类型】；

`swift`中这两个类型可以互相转换；

#### 10. throws 和 rethrows 的用法和作用

函数中会抛出错误的会使用`throws`关键字

```
enum DivideError: Error {
    case EqualZeroError;
}
func divide(_ a: Double, _ b: Double) throws -> Double {
    guard b != Double(0) else {
        throw DivideError.EqualZeroError
    }
    return a / b
}
```

`rethrows`表示函数本身不会抛出异常，但是作为参数的闭包抛出了异常，会继续把异常上抛；

#### 11. try？ 和 try！ 的作用

可以用来修饰会抛出异常的函数，使用这两个关键字可以不使用`do-catch`；

`try?`处理函数时，会把结果全部转换成可选类型，异常时为nil；

`try!`处理函数时，正常返回结果，异常时crash；

#### 12. associatedtype 的作用

`associatedtype`是协议中使用的泛型

```
protocol ListProtocol {
	associatedtype Element
	func pop(_ ele: Element) -> Element?
}

class IntList: ListProtocol {
	// 使用typealias指定特定类型
	typealias Element = Int
	func pop(_ ele: Int) -> Int?
}

class DoubleList: ListProtocol {
	// 自动推断
	func pop(_ ele: Double) -> Double?
}

// 用where限定类型
extension ListProtocol where Element == Int {
	func isInt() -> Bool {
		return true
	}
}
```

#### 13. final 的作用

用于限制 【继承】和 【重写】；

可以修饰【类】、【属性】、【方法】；

#### 14. public 和 open 的区别

访问权限修饰，open > public > internal > fileprivate > private

`private`: 所修饰的属性或者方法只能在当前类里访问；

`fileprivate`: 所修饰的属性或者方法在当前的swift源文件里可以访问；

`internal`: 默认的访问级别，所修饰的属性或者方法在源代码所在的整个模块都可以访问；如果实在框架内，或者库代码，则在整个框架内部都可以访问；框架由外部代码引用的时候，则不可以访问；

`public`: 可以被任何人访问，在其他`module`中不可以被`override`和继承，在`module`内可以被`override`和继承；

`open`: 可以被任何人使用，包括`override`和继承；

#### 15. 闭包的写法

* 排序方法

```
let test = ["b", "c", "a"]

func backward(_ s1: String, _ s2: String) -> Bool {
	return s1 > s2
}

let reversedTest = test.sorted(by: backward)
```

* 闭包表达式

```
{(parameters) -> return type in
	statements
}
```

```
reversedNames = names.sorted(by: {(s1: String, s2: String) -> Bool in 
	return s1 > s2
})

// 可以从上下文自动推断出类型
reversedNames = names.sorted(by: {s1, s2 in 
	return s1 > s2
})

// 单个表达式闭包的隐式返回
reversedNames = names.sorted(by: {s1, s2 in s1 > s2})

// 参数替换
reversedNames = names.sorted(by: {$0 > $1})

// 操作符方法
reversedNames = names.sorted(by: > )
```

#### 16. Self 的使用场景 (区别于self)

`Self`通常会在协议中使用，用来表示当前实现协议的类的类型(class)；

```
protocol CopyProtocol {
	func copySelf() -> Self
}

// 结构体可以直接实现，把Self替换为结构体的类型
struct SomeStruct: CopyProtocol {
	let value: Int
	func copySelf() -> SomeStruct {
		return SomeStruct(value: self.value)
	}
}

// 类实现这个协议，需要有required修饰的初始化方法，或者使用final关键字修饰这个类，目标是为了让这个类和他的子类都有init这个初始化方法；
class SomeClass: CopyProtocol {
	func copySelf() -> Self {
		return type(of: self).init()
	}
	required init(){}
}
```

#### 17. dynamic 的作用

`dynamic`可以配合`KVO`的使用。因为swift是静态语言，oc中的消息发送等动态的机制会失效，`dynamic`的作用就是使swift代码也能有oc的动态机制。

```
class KVOClass: NSObject {
	dynamic var someValue: String = "123"
	var otherValue: String = "abc"
}

class ObserverClass: NSObject {
	func addObserver() {
		let KVOClass()
		kvo.addObserver(self, forKeyPath: "someValue", options: .new, context: nil)
		kvo.addObserver(self, forKeyPath: "otherValue", options: .new, context: nil)
		kvo.someValue = "456"
		kvo.otherValue = "def"
		kvo.removeObserver(self, forKeyPath:"someValue")
		kvo.removeObserver(self, forKeyPath:"otherValue")
	}
	
	override func observerValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
		print("\(keyPath!) change to \(change![.newKey] as! String)")
	}
}

ObserverClass().addObserver()

// 只会输出 someValue change to 456
```

#### 18. 什么时候使用 @objc

需要使用`OC`与`Swift`混编的时候，可以使用`@objc`修饰类、协议、方法、属性；

标记了`@objc`的协议，只能被继承自`OC`的类或者`@objc`类实现，其他的类、结构体、枚举都不能使用；

#### 19. Optional(可选型)是怎么实现的

可选型是一个泛型的枚举

```
enum Optional<Wrapped> {
	case none
	case some(Wrapped)
}
```

定义泛型的时候除了使用`let someValue: Int? = nil`以外，也可以用`let someValue: Optional<Int> = nil`定义；

#### 20. 自定义下标获取

实现`subscript`方法

```
extension AnyList {
	subscrupt(index: Int) -> T {
		return self.list[index]
	}
}
```

#### 21. ？？的作用

`??`是空合运算符。

`let someValue = optionalValue ?? 0`

#### 22. lazy的作用

懒加载；

```
let numbers = 1...5
let doubleNumbers = numbers.lazy.map {(i: Int) -> Int in 
	print("numbers \(i)")
	return i * 2
}

for i in doubleNumbers {
	print("doubleNumbers \(i)")
}

/*
 打印结果
 numbers 1
 doubleNumbers 1
 numbers 2
 doubleNumbers 2
 ...
*/
```

#### 23. 一个类型表示表示选项，可以同时表示有几个选项选中(类似 UIViewAnimationOptions)，用什么类型表示

需要继承`OptionSet`，并且一般由`struct`实现。

原因是`OptionSet`需要有一个不可失败的`init(rawValue:)`构造器，枚举是可失败的；

```
struct SomeOption: OptionSet {
	let rawValue: Int
	static let option1 = SomeOption(rawValue: 1 << 0)
	static let option2 = SomeOption(rawValue: 1 << 1)
	static let option3 = SomeOption(rawValue: 1 << 2)
}

let options: SomeOption = [.option1, .option2]
```

#### 24. inout 的作用

可以让值类型的数据以引用方式传递，可以在函数内改变函数外面的变量的值；

#### 25. Error 如果要兼容 NSError需要做什么操作

`Swift自定义的Error`可以直接`SomeError.error1 as NSError`，但是会没有描述，错误码等信息。可以通过实现`LocalizedError`和`CustomNSError`协议，实现信息的补充;

```
enum SomeError: Error, LocalizedError, CustomNSError {
	case error1, error2
	public var errorDescription: String? {
        switch self {
        case .error1:
            return "error description error1"
        case .error2:
            return "error description error2"
        }
    }
    var errorCode: Int {
        switch self {
        case .error1:
            return 1
        case .error2:
            return 2
        }
    }
    public static var errorDomain: String {
        return "error domain SomeError"
    }
    public var errorUserInfo: [String : Any] {
        switch self {
        case .error1:
            return ["info": "error1"]
        case .error2:
            return ["info": "error2"]
        }
    }
}
print(SomeError.error1 as NSError)
// Error Domain=error domain SomeError Code=1 "error description error1" UserInfo={info=error1}
```

#### 26. 如何解决引用循环

* 转换为值类型，只有类会存在引用循环
* delegate使用weak属性
* 闭包中，对有可能发生引用循环的对象，使用`weak`或者`unowned`修饰

其中，使用`unowned`的场景为，修饰的变量不能为nil；否则使用`weak`;

#### 27. 下面的代码能否正常运行，说出原因

```
var mutableArray = [1,2,3]
for _ in mutableArray {
    mutableArray.removeLast()
}
```

不会crash，并且执行了3次；猜测因为`array`是【值类型】，在循环`for-in`开始的时候就已经进行了值捕获；

#### 28. 声明一个集合中元素是字符串的类型的扩展方法

```
extension Array where Element == String {
	func isStringElement() -> Bool {
		return true
	}
}

["1", "2"].isStringElement()
```

#### 29. 定义静态方法关键字的 static 和 class 有什么区别

`static`和`class`都是指定类方法；

`static`指定的类方法，不能被`override`

`class`指定的类方法，可以被`override`

### 高级

#### 1. sequence 的索引是不是一定从0开始

序列(Sequence)；

不是，内部存在位置指针，索引位置由这个属性决定

#### 2. 数组都实现了什么协议

* `Element`元素类型
* `Generator`生成器
* `Sequence`序列
* `Collection`集合
* `Index`下标

#### 3. 自定义模式匹配

疑似用`switch`分发不同类型的情况；

[参考链接](http://swifter.tips/pattern-match/)

#### 4. autoclosure 的作用

会把后面的表达式封装成闭包；

```
func logIfTrue(@autoclosure predicate: () -> Bool) {
	if predicate() {
		print("True")
	}
}

logIfTrue(2 > 1)
// 没有@autoclosure的情况
// logIfTrue{2 > 1}
```

其中原理可以通过`??`的方法实现分析出来

```
var level: Int?
var startLevel = 1

var currentLevel = level ?? startLevel

func ??<T>(optional: T?, @autoclosure defaultValue: () -> T) -> T {
    switch optional {
        case .Some(let value):
            return value
        case .None:
            return defaultValue()
        }
}
```

`@autoclosure`在这里有懒加载的思想在里面，可以在确定可选值为空的情况下，才去实现`??`后面的值；否则就要在一开始就要得到后面的值，如果这个值需要大量计算，那就有性能浪费了；

#### 5. 编译选项 whole module optmization 优化了什么

![](https://tva1.sinaimg.cn/large/006tNbRwgy1g9igyhlk75j30q607875d.jpg)

使得swift在编译阶段不会局限于一个文件做代码分析，而是整个module；可以避免一些在编译过程中会自动添加的类型推断的代码；

#### 6. 下面代码中 mutating 的作用是什么

```
struct Person {
	var name: String {
		mutating get {
			return store
		}
	}
}
```

`mutating`关键字本身加在方法前，可以为结构体、枚举这些值类型对象修改属性值；

此处的修饰为只有变量对象可以访问，不可变对象无法访问`name`属性;

#### 7. 让自定义对象支持字面量初始化



#### 8. dynamic framework 和 static framework 的区别是什么

`dynamic framework`动态库，多个程序之间共享;

`static framework`静态库，每个程序单独打包一份；
