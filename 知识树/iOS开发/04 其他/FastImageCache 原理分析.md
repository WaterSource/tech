## FastImageCache

### 加载图片的过程

iOS从磁盘加载一张图片，使用UIImageView显示在屏幕上，需要经过的步骤

* 1.从磁盘拷贝数据到内核缓冲区
* 2.从内核缓冲区复制数据到用户空间
* 3.生成UIImageView，把图像数据赋值给UIImageView
* 4.如果图像数据为未解码的PNG/JPG，解码为位图数据
* 5.CATransaction捕获到UIImageView layer树的变化
* 6.主线程Runloop提交CATransaction，开始进行图像渲染
	* 6.1 如果数据没有字节对齐，Core Animation会再拷贝一份数据，进行字节对齐
	* 6.2 GPU处理位图数据，进行渲染

### FastImageCache 实现的优化

* 使用了mmap内存映射，省去了第2步从内核空间拷贝数据到用户空间的操作
* 缓存解码后的位图数据到磁盘，下次从磁盘度去死省去了第4步解码的操作
* 生成字节对齐的数据，避免6.1的再次拷贝

### 使用 FastImageCache

适合用于tableView里缓存每个cell上同样规格的图像，优点是能极大的加快第一次从磁盘加载这些图像的速度；

缺点有两个：一个是占空间大。

解析后的位图是很大的，宽高100*100的图像在2x的高清屏设备下就需要`200*200*4byte/pixel = 156KB`，这也是为什么 FastImageCache在限制缓存大小。

二是接口不友好，使用的时候需要预定义好图像的尺寸。
