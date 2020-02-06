## Bitmap 位图

### 了解bitmap

位图，又称栅格图或点阵图。是使用像素阵列来表示的图像。

位图的像素都分配有特定的位置和颜色值。

每个像素的颜色信息由`RGBA`组合或者灰度值`YUV`表示;

根据深度可将位图分为1、4、8、16、24、32位(bite)(8bite = 1byte)

* ALPHA_8 一个像素8位(bit)(1个字节)，只有透明度
* ARGB_4444 一个像素4(R)+4(G)+4(B)+4(A)，16位(2个字节)
* ARGB_8888 (The common one)8+8+8+8，32位(4个字节)
* RGB_565 每个像素5(R)+6(G)+5(B)，16位(2字节)，绿色多一位是因为人类对绿色更敏感，识别的范围更大
* planar8 YUV格式

### iOS中的Bitmap

```
CGImageCreate

// 通过已经存在Image对象创建
CGImageSourceCreate - ImageAtIndex
// 创建缩略图
CGImageSourceCreate - ThumbnailAtIndex
// 通过copy Bitmap Graphics来创建
CGBitmapContextCreateImage
// 通过图片部分数据创建
CGImageCreateWith - ImageInRect
```

```
let w = Int(image.size.width)
let h = Int(image.size.height)
let bitsPerComponent = 8
let bytesPerRow = w * 4
let colorSpace = CGColorSpaceCreateDeviceRGB()
let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
let bufferData = UnsafeMutablePointer<UInt32>.allocate(capacity: w * h)
bufferData.initialize(repeating: 0, count: w * h)
let cxt = CGContext(data: bufferData,
                    width: w,
                   height: h,
         bitsPerComponent: bitsPerComponent,
              bytesPerRow: bytesPerRow,
                    space: colorSpace,
               bitmapInfo: bitmapInfo)
```

* space 颜色空间
	* RGBA
	* CMYK
	* 灰度值
* bitmapInfo 一个常量，描述位图上下文所对应的位图基本信息
	* 通常是 CGBitmapInfo和CGImageAlphaInfo 做或运算的最终值
	* 制定是否有alpha通道，alpha的位置(RGBA还是ARGB)，字节的排序等

