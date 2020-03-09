## 图像处理

### OpenGL ES

#### OpenGL1.0和2.0的区别

1.0是针对固定管线硬件(fixed pipeline)，通过内建的functions来设置诸如灯光，vertexes(图形的顶点数)，颜色，camera等等的东西;

2.0是可编程的管线硬件(programmable pipeline)，不再支持内建函数，需要手动编写所有功能；

#### Pipeline 渲染管线

在渲染处理过程中会按顺序执行一系列操作，这一系列相关的处理阶段就是OpenGL ES的渲染管线。

![](https://tva1.sinaimg.cn/large/006tNbRwgy1ga6yk0x0j1j30fi0bmaaz.jpg)

学习OpenGL就是学习整个图的每一个部分，是OpenGL的架构图；阴影部分的两个`shader`都是可编程管线，也就是说这个操作可以动态编程实现，而不必固定写死在代码中；

可动态编程实现也就是用脚本实现，在OpenGL中是用着色语言(Shader Language)实现；

`Vertex Array/Buffer objects`顶点数据来源，是渲染管线的顶点输入，通常是用`buffer objects`效果更好。

`Vertex Shader`顶点着色器，通过可编程的方式实现对顶点的操作，可以进行空间转换，计算`per-vertex color`，纹理坐标；

`Primitive Assembly`图元装配

* 经过着色器处理之后的顶点在图片装配阶段被装配为基本图元；`OpenGL`支持三种基本图元:点、线、三角形，是可以被`OpenGL ES`渲染的；
* 对装配好的图元进行裁剪(clip)，保留在视锥体中的图元，丢弃完全不在视锥体中的图元，对一半在一半不在的图元进行裁剪；
* 接着再对在视锥体中的图元进行剔除处理(cull)，可以用代码实现决定是剔除正面，背面还是全部剔除；

`Rasterization`光栅化，基本图元会被转换为二维的片元(fragment)，`fragment`表示可以被渲染到屏幕上的像素，包含位置、颜色、纹理坐标等信息，这些值是通过图元的顶点信息进行插值计算得到的。这些`fragment`接着被送到片元着色器中处理。

![](https://tva1.sinaimg.cn/large/006tNbRwgy1ga6z8289rfj30q10el75w.jpg)

`Fragment Shader`片元着色器，通过可编程的方式实现对片元的操作。正如上一步所说，这一步会接受光栅化处理之后的`fragment`，`color`，深度值，模板值作为输入；

`Per-Fragment Operation`在这一阶段会对片元着色器输出的每一个片元进行测试与处理，最后决定用于渲染的像素；

这一阶段具体的处理过程如图:

![](https://tva1.sinaimg.cn/large/006tNbRwgy1ga6z9vr6zwj30gw05cjru.jpg)

`Pixel ownership test`该测试决定像素在`framebuffer`中的位置是不是为当前`OpenGL ES`所有，测试某个像素是否对用户可见，或者被重叠窗口阻挡；

`Scissor test`剪裁测试，判断像素是否在由`GLScissor`定义的剪裁矩形内，不在该区域内的像素会被剪裁掉；

`Stencil test`模板测试，将模板缓存中的值与一个参考值进行比较，从而进行相应的处理；

`Depth test`深度测试，比较下一个片段与帧缓冲区中的片段的深度，从而决定哪一个像素在前面，哪一个像素被遮挡；

`Blending`混合，混合是将片段的颜色和帧缓冲区中已有的颜色值进行混合，并将混合所得的新值写入帧缓冲；

`Dithering`抖动，抖动是使用有限的色彩让你看到比实际图像更多色彩的显示方式，以缓解表示颜色的值的精度不够大而导致的颜色巨变的问题。

`Framebuffer`是流水线的最后一个阶段，`FrameBuffer`中存储着可以用于渲染到屏幕或者纹理中的像素值，也可以从`FrameBuffer`中读回像素值，但是不能读取其他值(例如深度，模板值等)。

#### 屏幕坐标系

三点确定一个三角形，我们常用“顶点”来指代3D图形学中的点。一个顶点有三个坐标，X、Y、Z。

X轴向右，Y轴向上，Z轴向后；

```
// 包含3个3维向量的数组
static const GLfloat g_vertex_buffer_data[] = {
	-1.0f, -1.0f, 0.0f,
	1.0f, -1.0f, 0.0f,
	0.0f, 1.0f, 0.0f,
};
```

GPU内置的坐标系


#### 着色器 Shader

编译着色器分为两种，顶点着色器(vertex shader)，他作用于每个顶点上；片段着色器(fragment shader)，他作用于每一个采样点。

