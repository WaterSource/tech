## UIView

UIView主要是负责以下几种任务

1. 绘制和动画
2. 布局和子视图管理
3. 事件处理

#### UIView和CALayer的关系和区别

UIView是layer的一层封装，layer是view的一个属性。

UIView负责接收响应事件，继承自`UIReponder`。

CALayer是图层，继承自`NSObject`。修改layer的可视属性会同步修改view的可视属性。



### 绘制和动画

当视图内容发生变化时，需要调用 `setNeedsDisplay` 或者 `setNeedsDisplayInRect:` 方法，告诉系统该重新绘制这个视图了。调用这个方法之后，系统会在下一个绘制周期更新这个视图的内容。由于系统要等到下一个绘制周期才真正进行绘制，可以一次性对多个视图调用 `setNeedsDisplay`，它们会同时被更新。

#### bounds

bounds是相对与自身的位置范围，可以认为是当前view被允许绘制的范围。

#### 视图的ContentMode

视图在初次绘制完成后，系统会对绘制结果进行快照，之后尽可能地使用快照，避免重新绘制。如果视图的几何属性发生改变，系统会根据视图的 contentMode 来决定如何改变显示效果。

默认的 contentMode 是 `UIViewContentModeScaleToFill` ，系统会拉伸当前的快照，使其符合新的 frame 尺寸。大部分 contentMode 都会对当前的快照进行拉伸或者移动等操作。如果需要重新绘制，可以把 contentMode 设置为 `UIViewContentModeRedraw`，强制视图在改变大小之类的操作时调用`drawRect:`重绘。

### 布局和子视图管理

#### AutoResizing 和 Constraint

当一个视图的大小改变时，它的子视图的位置和大小也需要相应地改变。UIView 支持自动布局，也可以手动对子视图进行布局。

当以下事件发生时，需要进行布局操作

1. 视图的bounds大小改变
2. 界面旋转
3. layer层的Core Animation sublayers发生改变
4. 程序调用视图的 `setNeedsLayout` 或 `layoutIfNeeded` 方法
5. 程序调用视图 layer 的 `setNeedsLayout`方法

##### AutoResizing

视图的`autoresizesSubviews`属性决定了在视图大小发生变化时，如何自动调节子视图；

是可以通过位运算符组合起来的的

`UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth`

##### Constraint

Constraint是另一种用于自动布局的方法

`attribute1 == multiplier * attribute2 + constant`

### 事件处理

通常可以通过添加手势来处理响应的触控事件；

要手动处理的话，需要重载下面四个函数

`touchesBegan:withEvent:`
`touchesMoved:withEvent:`
`touchesEnded:withEvent:`
`touchesCancelled:withEvent:`

## UIViewController

VC的生命周期

1. `-(void)loadView`
2. `-(void)viewDidLoad`
3. `-(void)viewWillAppear`
4. `-(void)viewWillLayoutSubviews`
5. `-(void)viewDidLayoutSubviews`
6. `-(void)viewDidAppear`
7. `-(void)viewWillDisappear`
8. `-(void)viewDidDisappear`

```
- (void)willMoveToParentViewController:(nullable UIViewController *)parent {
	if (!parent) {
		// 离开页面
	}
}

触发时机可以定义为退出该页面。区别于viewWillDisappear,viewWillDisappear可以是push了一个新页面还有机会返回。
```
