
<font size="5">Table Of Content</font>


* [At a glance](#1)
	* [Spacing](#1.1)
	* [换行](#1.2)
* [命名](#2)
	* [Camel case](#2.1)
	* [Class prefix](#2.2)
	* [泛型](#2.3)
	* [英文语法](#2.4)
	* [权限](#2.5)
* [语言特性](#3)
	* [Marco](#3.1)
	* [Optional](#3.2)
	* [Implicitly Unwrapped Optional](#3.3)
	* [guard-else](#3.4)
    * [Extension](#3.5)
    * [Lazy Loading](#3.6)
 	* [self. ?](#3.7)
	* [Method vs function](#3.8)
	* [Closure](#3.9)
	* [Enum](#3.10)
	* [文档](#3.11)
* [代码结构](#4)
	* [业务相关](#4.1)
	* [Selector](#4.2)

<h2><font size="5" id="1">At a glance</font></h2>

<font size="4" color="#3271ad" id="1.1">Spacing</font>



<del> Swift 的代码相对于 OC 来说适合更紧凑的风格，`spacing` 方面我强烈建议用 `2` 个单位的Spacing，具体可以看看下面的对比，Spacing `2` 看起来会比较舒服：

<font color="green">Preferred</font>
~~~Swift
class A {
  var name = "Hello"
  func foo() {
    print("Haha")
  }
}
~~~
<font color="red"><font color="red">Not Preferred</font></font>
~~~Swift
class A {
    var name = "Hello"
    func foo() {
        print("Haha")
    }
}
~~~
<del>至于用 `Tab` 还是空格... 大家自己怎么爽怎么来，想方便的话 `Xcode` 的 `indent` 改一下。

缩进一律使用 `4` 各单位。

而在声明变量类型时，`:`，`,`，`=` 后面应该加入空格使得水平方向的排版更加清晰：

<font color="green">Preferred</font>
~~~Swift
class Car: Vehicle, Flyable {
  ...
}
func request(url: NSURL, method: Method) {}
var dictionary = ["A": 1, "B": 2]
~~~


<font color="red">Not Preferred</font>
~~~Swift
class Car:Vehicle,Flyable {
  ...
}
func request(url:NSURL, method:Method) {}
var dictionary=["A":1, "B":2]
~~~

<font size="4" color="#3271ad" id="1.2">换行</font>

无论是 `class` `stuct` `enum`，对于出现大括号的语句，应该跟前方内容保持在同一行：


<font color="green">Preferred</font>
~~~Swift
class Person {
  ...
}
func foo() {
  ...
}
~~~
<font color="red">Not Preferred</font>
~~~Swift
class Person
{
  ...
}
func foo()
{
  ...
}
~~~

但对于 `if-else` 来说，`else` 应留在同一行：

<font color="green">Preferred</font>
~~~Swift
if condition {
    print("Yes")
} else {
    print("No")
}
~~~

<font color="red">Not Preferred</font>
~~~Swift
if condition {
    print("Yes")
} 
else {
    print("No")
}
~~~ 

Swift 提供了 `guard-else` 语句，若 `else` 内部只执行了简单的退出语句，则将 `else` 保留在同一行：

<font color="green">Preferred</font>
~~~Swift
guard person != nil else { 
    fatalError("This is a longgggggggggggggggggggggggggggggggggggggggggggggg error")
  }
guard let car = car else { return }
~~~


<font color="red">Not Preferred</font>
~~~Swift
guard person != nil else { fatalError("This is a longgggggggggggggggggggggggggggggggggggggggggggggg error")}
guard let car = car 
  else { return }
~~~

<h2><font size="5" id="2">命名</font></h2>

<font size="4" color="#3271ad" id="2.1">Camel case</font>


整体命名方面，对于 `class`，`enum`，`protocol`，`struct` 应该是首字母大写的驼峰命名 `PascalCase`，而变量遵循首字母小写命名 `camelCase`，这点跟 OC 差不多；这里特殊说一下 `protocol` 的 `associatedtype` 也应该遵循 `PascalCase`，`typealias` 也一样：

<font color="green">Preferred</font>
~~~Swift
protocol Sequence {
    associatedtype IteratorType: Iterator
}
typealias MyType Int32
~~~ 

<font size="4" color="#3271ad" id="2.2">Class prefix</font>

Swift 支持 `namespace`，所以不需要像 OC 一样给前缀，自己模块内部的命名也可以更加通用化，不需像 OC 一样那么长：
~~~Swift
// <font color="green">Preferred</font>
import VVModule
class LocationManager {
  ...
}
let manager = VVModule.LocationManager()

// <font color="red">Not Preferred</font>
class VVLocationManager {
  ...
}
~~~

<font size="4" color="#3271ad" id="2.3">泛型</font>

Swift 支持泛型，参考 Swift 自己的实现，通常均使用 `T` `U` `V` 来指代，Swift 官方自己定义一些类型如 `Element`，此时应该跟官方的保持一致，除此之外一律使用 `T` `U` `V` 单字母替代：

<font color="green">Preferred</font>
~~~Swift
struct Stack<Element> { ... }
func swap<T>(_ a: inout T, _ b: inout T)
~~~


<font color="red">Not Preferred</font>
~~~Swift
struct Stack<T> { ... } //
func swap<Thing>(_ a: inout Thing, _ b: inout Thing)
~~~

<font size="4" color="#3271ad" id="2.4">函数</font>

在函数命名方面，参考官方的一些命名，func 的第一个参数命名应该在括号之内：


<font color="green">Preferred</font>
~~~Swift
public mutating func remove(_ member: Element) -> Element?
allViews.remove(cancelButton) // clearer
~~~


<font color="red">Not Preferred</font>
~~~Swift
public mutating func removeElement(_ member: Element) -> Element?
allViews.removeElement(cancelButton)
~~~


但这里对于一些 OC 对象来说，Swift 将它们定义为弱类型（比如一个 `NSObject` 可能是任何东西，同样 `String` `Int`也是，它们有可能认为的造成错误），这里 Swift 官方给出的建议是将它们包含到 `func` 命名部分而不是参数，让使用者可以得到更确切的信息，减少出错的可能：


<font color="green">Preferred</font>
~~~Swift
func addObserver(_ observer: NSObject, forKeyPath path: String) // 
grid.addObserver(self, forKeyPath: graphics) // clear
~~~

<font color="red">Not Preferred</font>
~~~Swift
func add(_ observer: NSObject, for keyPath: String) // for what? vs for a key path 
grid.add(self, for: graphics) // vague
~~~


对于有可能造成歧义的 `func` 命名应该尽量避免，Swift 自身提供了辅助命名：


<font color="green">Preferred</font>
~~~Swift
extension List {
  public mutating func remove(at position: Index) -> Element
}
employees.remove(at: x)
~~~


<font color="red">Not Preferred</font>
~~~Swift
employees.remove(x) // unclear: are we removing x?
~~~


<font size="4" color="#3271ad" id="2.5">英文语法</font>

在命名时，语法也是需要考虑的，应该使用 **连贯语法规则**，增加整体的可读性：


<font color="green">Preferred</font>
~~~Swift
x.insert(y, at: z)          // x, insert y at z, neat!
x.subViews(havingColor: y)  // x's subviews having color y
x.capitalizingNouns()       // x, capitalizing nouns
~~~

<font color="red">Not Preferred</font>
~~~Swift
x.insert(y, position: z) 
x.subViews(color: y)
x.nounCapitalize() 
~~~


但有一种情况需要额外考虑。我们都知道，在 OC 里面，工厂方法我们倾向于 `personWithName:Color:` 这样一个 `名词` 加 `介词` 的命名方式，像此类工厂方法，在 Swift 中我们应该用 make 开头，同时将所给的参数独立开来，让整体可读性提高：


<font color="green">Preferred</font>
~~~Swift
let foreground = Color(red: 32, green: 64, blue: 128)
let newPart = factory.makeWidget(gears: 42, spindles: 14)
let ref = Link(target: destination)
~~~


<font color="red">Not Preferred</font>
~~~Swift
let foreground = Color(havingRGBValuesRed: 32, green: 64, andBlue: 128)
let newPart = factory.makeWidget(havingGearCount: 42, andSpindleCount: 14)
let ref = Link(to: destination)
~~~


除了工厂方法，若该 `func` 所提供的参数具有同等性，我们可以暂时忽略 **连贯语法规则**，将 `介词` 加入到函数命之中，再将各个参数独立开来，但切记只有这种情况可以忽略 **连贯语法规则**：


<font color="green">Preferred</font>
~~~Swift
a.moveTo(x: b, y: c)
a.fadeFrom(red: b, green: c, blue: d)
~~~


<font color="red">Not Preferred</font>
~~~Swift
a.move(toX: b, y: c)
a.fade(fromRed: b, green: c, blue: d)
~~~

对于 `protocol` 来，应该尽量使用 `able` `ing` `ly` 结尾，若无法准确构词则使用 `Protocol` 作为结尾：


<font color="green">Preferred</font>
~~~Swift
protocol JSONable {}
protocol Networking {}
protocol Touchable {}
~~~

<font size="4" color="#3271ad" id="2.5">权限</font>

Swift 中控制权限相关的关键字有：`open` `public` `internal` `fileprivate` `private`，它们分别代表：


* `open` 表示没有任何限制
* `public` 表示在 module 外无法被修改或者继承
* `internal` 表示在 framework 中使用，无法在 framework 外部进行修改
* `fileprivate` 表示在文件内部访问（在其他文件 extension 时也无法使用）
* `private` 最低权限，只允许在内部使用

权限关键字很重要，我们在声明时应该将它们摆在第一位，避开 `lazy` `static` 等：

<font color="green">Preferred</font>
~~~Swift
struct Person {
  private static let firstName = "xxx"
}
~~~

<font color="red">Not Preferred</font>
~~~Swift
struct Person {
  static private let firstName = "xxx"
}
~~~

<h2><font size="5" id="3">语言特性</font></h2>

<font size="4" color="#3271ad" id="3.1">Marco，全局常量</font>

Swift 不在提供 `marco`，对于一些系统常量，我们应该单独放到一个 module 然后使用 `struct` 或者 `enum`，这样无论从管理或者使用方面都会更好：


<font color="green">Preferred</font>
~~~Swift
struct Math {
  static let e = 2.718281828459045235360287
  static let root2 = 1.41421356237309504880168872
}


let e = Math.e
~~~


<font color="red">Not Preferred</font>
~~~Swift
let e = 2.718281828459045235360287  // pollutes global namespace
let root2 = 1.41421356237309504880168872
~~~

<font size="4" color="#3271ad" id="3.2">Optional</font>


Swift 作为一门非常注重类型的语言，其中一个最大的特性就是 `Optional`，我们应该多使用这一特性，比如说我们有一个 `ViewController` 用于搜索用户后进行展示，那这个时候 `Optional` 可以派上用场：
~~~Swift
class UserSearchViewController: UIViewController {
  var user: User?
}
~~~


执行搜索逻辑之后，我们只需要解 `user` 就可以接着渲染对应的 UI。上面的这个例子也是 **依赖注入** 的一个应用，在写测试的时候我们可以通过直接注入 `user` 来写各种测试 case


使用 `Optional` 的时候，永远不要强制解值：


<font color="green">Preferred</font>
~~~Swift
var user: User?
guard let user = user else { return }
~~~


<font color="red">Not Preferred</font>
~~~Swift
var user: User?
let length = user!.count // Don't do this !
~~~


若需要通过某 `Optional` 来进行一些列后续操作，不要解 `Optional` 而是通过 `Optional Chaining` 来做：


<font color="green">Preferred</font>
~~~Swift
var user: User?
user?.friend?.address?.show()
~~~

<font color="red">Not Preferred</font>
~~~Swift
var user: User?
update(user!) // Never do this !!!
~~~


<font size="4" color="#3271ad" id="3.3">Implicitly Unwrapped Optional</font>


还是看上面的例子，现在我们把需求变为：搜索不到用户则显示自己，那我们可以这样改：
~~~Swift
class UserSearchViewController: UIViewController {
  var user: User！
}
~~~

这意味着 `user` 这一变量除了一开始为空，后续它都会有相应的值，再举一个系统本身的例子，`UIViewController` 的 `view` 就是 **Implicitly Unwrapped Optional**

<font size="4" color="#3271ad" id="3.4">guard</font>


Swift 提供了 `guard-else` 语句，它能让我们避免许多嵌套语句的产生，从代码设计的角度来看，我们可以多使用 `guard` 来确保整个逻辑的清晰度：


<font color="green">Preferred</font> 
~~~Swift
func selectAtIndex(_ index: Int) {
  guard index < 10 && index > 0 else { return }
  
  let user = data[index]
  refreshView(with: user)
}
~~~

<font color="red">Not Preferred</font> 
~~~Swift
func selectAtIndex(_ index: Int) {
  if index < 10 && index > 0 {
    let user = data[index]
    refreshView(with: user)
  }
}
~~~


这里需要注意，`guard` 作用的是一种偏向退出的代码风格 `guard-else` 中的 `else` 不应该勇于处理繁重的逻辑，对于需要分开处理的情况，请使用 `if-else`

<font size="4" color="#3271ad" id="3.5">Extension</font>


Swift 提供了 extension 这一功能，他能让整个 module 显得更有条理性


对于 protocol 来说，均通过 extension 来遵循：
~~~Swift
class ProfileViewController: UIViewController {
}


extension ProfileViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	return 100
  }
}


extension ProfileViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
}
~~~

同样的，我们也可以使用 extension 来将某个类按业务拆分开来：


~~~Swift
// MARK: Change Avatar
extension ProfileViewController { 
  // ... 
}
// MARK: Change BirthDate
extension ProfileViewController {
  // ... 
}
~~~

<font size="4" color="#3271ad" id="3.6">Lazy Loading</font>



在 OC 里面，Lazy Loading 对于提高整个类的条理性有着很大的作用（比如统一将所有 UI 相关的 `property` 都放到 .m 文件的最后），遗憾的是 extension 不支持 store property，所以这里我们约定，lazy loading 的 property 统一放在每个类的最前端，通过 `lazy` 关键字修饰，然后统一定义工厂方法：

~~~Swift
class ProfileViewController {
  lazy var tableView = makeTableView()
  lazy var avatarView = makeAvatarView()
}
// MARK: Lazy Loading
extension ProfileViewController {
  func makeTableView() { ... }
  func makeAvatarView() { ... }
~~~

<font size="4" color="#3271ad" id="3.7">self. ?</font>

官方给的建议是，除非编译器需要，否则不要使用 `self` 去访问类里边的函数或者方法，什么叫编译器需要，例如为了打破 `closure` 里面的循环引用：
~~~Swift
resource.request().onComplete { [weak self] response in
  guard let strongSelf = self else {
    return
  }
  let model = strongSelf.updateModel(response)
  strongSelf.updateUI(model)
}
~~~

<font size="4" color="#3271ad" id="3.8">Method vs Function</font>


尽可能的多用对象的 `.` 语法，而不是用一个函数调用，这样整体的可读性更好：


<font color="green">Preferred</font> 
~~~Swift
let data = [1, 3, 4, 5]
data.sorted()
~~~

<font color="red">Not Preferred</font> 
~~~Swift
let data = [1, 3, 4, 5]
Sort(data)
~~~



<font size="4" color="#3271ad" id="3.9">Closure</font>


使用 closure 时，如果作为最后一个参数应该使用短语法：


<font color="green">Preferred</font> 
~~~Swift
UIView.animate(withDuration: 1.0) {
  self.myView.alpha = 0
}
~~~

<font color="red">Not Preferred</font> 
~~~Swift
UIView.animate(withDuration: 1.0, animations: {
  self.myView.alpha = 0
})
~~~

对于链式调用的场景，尽量使用 `anonymous arguments` 来访问，若一个语句长度超过限制，则考虑换行，避免一个语句过于冗长：

<font color="green">Preferred</font> 
~~~Swift
let value = numbers
  .map { $0 * 2 }
  .filter { $0 % 3 == 0 }
  .index(of: 90)
~~~

<font size="4" color="#3271ad" id="3.10">Enum</font>


在使用 `enum` 的时候，应该避免定义 `default` case，因为 `enum` 的初衷是所有的 case 都会被对应到，实现 `default` 情况往往证明有的 case 没有被覆盖，所以我们要做的是 cover all case，拒绝 `default`：


<font color="green">Preferred</font> 
~~~Swift
enum Face {
  case front, back 
  
  func show() {
    switch self {
    case .front:
	  print("Front")
	case .back:
	  print("Back")
    }
  }
}
~~~

<font color="red">Not Preferred</font> 
~~~Swift
enum Face {
  case front, back 
  
  func show() {
    switch self {
    case .front:
	  print("Front")
    default:
      print("Unknown")
    }
  }
}
~~~

<font size="4" color="#3271ad" id="3.11">文档</font>


对于工具类，文档还是必不可少的，不需要写的很详细，但下面这几个点应该是必须的：


* 这个类负责做什么
* 每个方法有没有什么事项要注意 `Warning`
* 方法间有没有什么联系 `SeeAlso`


格式方面多行内容用 `/** .... */`，这样的优势在于我们可以折叠注释部分，直接使用 Xcode 的 `Quick Help` 来查看；单行内容用 `/// ....` 其中关键字部分（e.g SeeAlso, Warning）可以关注 [官方的文档](https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html#//apple_ref/doc/uid/TP40016497-CH2-SW1)


<font color="green">Preferred</font> 
~~~Swift

/// Handle Network Stuff
class Network {


  /** Request some resource from a given url
	
	- Parameter url The url
	- Returns: A generic result 

   */
  func request(_ url: URL) -> Result<T> {
    ...
  }
}
~~~


<h2><font size="5" id="4">代码结构</font></h2>
<font size="4" color="#3271ad" id="4.1">业务相关</font>


对于 Controller 相关的业务类，均通过 `// MARK: -` 来分隔不同业务，一般来说有这几点：


`class` 定义体内，前半部分暴露 `public` 部分，`private` 相关放在后半部分


<font color="green">Preferred</font> 
~~~Swift
/// A Dog
class Dog {
  // MARK: - Public
  func move() { //... }


  // MARK: - Private
  fileprivate var gender = .male


  enum Gender {
    case male, female
  }
}
~~~


对于有默认实现的 `protocol` 我们将它放在 `class` 定义体之后，以便于维护者可以第一时间获取这个信息，紧接其后的是需要业务方自己实现的 `protocol`


<font color="green">Preferred</font> 
~~~Swift
/// A ViewController
class ViewController { }


// MARK: - Default Implementation Protocol
extension ViewController: CunsomPresentable {}


// MARK: - Protocol
extension ViewController: UITableViewDataSource {
  tableView(_ tableView: UITableView, numberOfRowAtSection section: Int) { } 
}
~~~


接着是 `ViewController` 的生命周期部分，也往往是整个 `ViewController` 所承载的业务主体；然后是 UI 布局相关，响应事件，懒加载，总结一些整体的机构应该是：


* `// MARK: - 类定义`
* `// MARK: - 类公共接口`
* `// MARK: - 类私有相关接口`
* `// MARK: - 业务方遵循已有默认实现协议`
* `// MARK: - 业务方实现协议`
* `// MARK: - 生命周期`
* `// MARK: 业务相关`
* `// MARK: - UI 布局相关`
* `// MARK: - 响应事件相关`
* `// MARK: - Actions`
* `// MARK: - 懒加载相关`


<font size="4" color="#3271ad" id="4.2">Selector</font>


关于 Selector 特别说下，为了获得更好的可读性，我们约定通过 `fileprivate extension Selector` 来管理：


<font color="green">Preferred</font> 
~~~Swift
// MARK: - 响应事件相关
fileprivate extension Selector {
  static let pushProfileModule = #selector(ViewController.buttonDidTouchUpInside(sender:))
}

// MARK: - Actions
extension ViewController {
  @objc func buttonDidTouchUpInside(sender: UIButton) {
  }
}
~~~


后续维护着只需关注 `fileprivate extension Selector` 即可知道当前模块负责了哪些动作。


<font size="4" color="#3271ad" id="4.1">Xcode Template</font>
关于代码结构部分我提供了一个 `Xcode Template` 来提高效率，详情可到[这里](http://cf.meitu.com/confluence/display/shanliao/Xcode+Template) 



