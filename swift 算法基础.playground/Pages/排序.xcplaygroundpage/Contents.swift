//: [Previous](@previous)

import Foundation

// 关于复杂度
// n代表输入数据的量
// O(n)，线性，遍历算法
// O(nlogn)，这里的log是以2为底的。数据增大256倍时，耗时增大256*8倍。复杂度高于线性低于平方；
// O(1)，耗时和数据大小无关。哈希算法就是典型的O(1)时间复杂度，无论数据规模多大，都可以在一次计算后找到目标（不考虑冲突的话）。

// 关于稳定性
// 描述算法对原始序列处理前后，该序列相等大小的元素前后位置是否发生改变


let testList = [8, 10, 3, 2, 5, 1, 7, 9, 4, 6]

// 冒泡排序 O(n*n)

func bubbleSort(array: inout [Int]) {
    for i in 0..<array.count-1 {
        for j in 0..<array.count-1-i {
            if array[j] > array[j+1] {
                (array[j+1], array[j]) = (array[j], array[j+1])
            }
        }
    }
}

//var bubbleList = testList
//bubbleSort(array: &bubbleList)
//print("冒泡排序", bubbleList)

// 插入排序 O(n*n)

func insertSortA(array: inout [Int]) {
    print("开始插入排序 共\(array.count)轮")
    for i in 1..<array.count {
        var j = i
        for _ in 1...i {
            print("第\(j)位的", array[j], "和第\(j-1)位的", array[j], "比较大小")
            if array[j] < array[j-1] {
                (array[j], array[j-1]) = (array[j-1], array[j])
            }
            j -= 1
        }
        
        print(array)
    }
}

//var insertListA = testList
//insertSortA(array: &insertListA)
//print("插入排序", insertListA)

func insertSortB(array: inout [Int]) {
    print("开始插入排序 共\(array.count)轮")
    for i in 1..<array.count {
        print("第\(i)轮 取出", array[i])
        let tmp = array[i]
        var j = i
        for _ in 1...i {
            print("第\(j-1)位的", array[j-1], "和取出值", tmp, "比较大小")
            if array[j-1] > tmp {
                array[j] = array[j-1]
                print("产生后移", array)
            } else {
                print("提前结束比较")
                break
            }
            j -= 1
        }
        print("结束比较")
        array[j] = tmp
        print(array)
    }
}

//var insertListB = testList
//insertSortB(array: &insertListB)
//print("插入排序", insertListB)

// 归并排序 O(nlogn)

func mergeSort(array: inout [Int], _ helper: inout [Int], _ low: Int, _ high: Int) {
    guard low < high else {
        return
    }
    
    let middle = (high - low) / 2 + low
    print("归并 \(array)，low:\(low) mid:\(middle) high:\(high) ")
    mergeSort(array: &array, &helper, low, middle)
    mergeSort(array: &array, &helper, middle + 1, high)
    merge(array: &array, &helper, low, middle, high)
}

func merge(array: inout [Int], _ helper: inout [Int], _ low: Int, _ middle: Int, _ high: Int) {
    for i in low...high {
        helper[i] = array[i]
    }
    
    var helperLeft = low
    var helperRight = middle + 1
    var current = low
    
    print("起始 arr:\(array) low:\(low) mid:\(middle) high:\(high)")
    print("起始 hel:\(helper)")
    
    var times = 0
    
    while helperLeft <= middle && helperRight <= high {
        print("第\(times)轮，helpLeft:\(helperLeft) - \(array[helperLeft]) helpRight:\(helperRight) - \(array[helperRight]) current:\(current) - \(array[current])\n")
        
        if helper[helperLeft] <= helper[helperRight] {
            array[current] = helper[helperLeft]
            helperLeft += 1
        } else {
            array[current] = helper[helperRight]
            helperRight += 1
        }
        current += 1
        
        times += 1
    }
    
    guard middle - helperLeft >= 0 else {
        return
    }
    
    for i in 0...(middle-helperLeft) {
        array[current + i] = helper[helperLeft + i]
    }
}

//var testListA = testList
//print("归并排序开始", testListA)
//var helperListA = Array(repeating: 0, count: testListA.count)
//mergeSort(array: &testListA, &helperListA, 0, testListA.count-1)
//print("归并排序", testListA)

// 快速排序 O(nlogn)
// 分块分基准数，按大小放置在基准数两侧

func quickSort(arr: inout [Int], begin: Int, end: Int) {
    guard begin < end else {
        return
    }
    
    var left = begin
    var right = end
    let pivot = arr[left]
    
    print("基准数是\(pivot)")
    
    var times = 0
    
    while left < right {
        
        // 因为基准值取得最左，所以必须要先从右找起
        
        // 从右向左找第一个小于key的值
        while pivot <= arr[right], left < right {
            right -= 1
        }
        
        // 从左向右找第一个大于key的值
        while arr[left] <= pivot, left < right {
            left += 1
        }
        
        print("第\(times)次", "左侧的数为\(left)的\(arr[left])","右侧的数为\(right)的\(arr[right])")
        
        if left < right {
            (arr[left], arr[right]) = (arr[right], arr[left])
        }
        
        times += 1
    }
    
    (arr[begin], arr[left]) = (arr[left], arr[begin])
    
    // 左半边
    quickSort(arr: &arr, begin: begin, end: left-1)
    // 右半边
    quickSort(arr: &arr, begin: right + 1, end: end)
}

//var quickList = testList
//quickSort(arr: &quickList, begin: 0, end: quickList.count-1)
//print("快速排序", quickList)

// 选择排序 O(n*n)
// 两级遍历，查找区域中的最小值

func selectSort(arr: inout [Int]) {
    for i in 0..<arr.count {
        var minIndex = i
        
        for j in i+1..<arr.count {
            if arr[j] < arr[minIndex] {
                minIndex = j
            }
        }
        
        if minIndex != i {
            (arr[i], arr[minIndex]) = (arr[minIndex], arr[i])
        }
    }
}

//var selectList = testList
//selectSort(arr: &selectList)
//print("选择排序", selectList)

// 堆排序 O(1)

func heapCreate(items: inout Array<Int>) {
    var i = items.count
    while i > 0 {
        heapAdjast(items: &items, startIndex: i-1, endIndex: items.count)
        i -= 1
    }
}

/// 对大顶堆的局部进行调整
///
/// - Parameter endIndex: 当前要调整的节点
func heapAdjast(items: inout Array<Int>, startIndex: Int, endIndex: Int) {
    let temp = items[startIndex]
    // 父节点下标
    var fatherIndex = startIndex + 1
    // 左孩子下标
    var maxChildIndex = 2 * fatherIndex
    
    print("取出在\(startIndex)的\(temp)")
    
    while maxChildIndex <= endIndex {
        print("当前父节点是在\(fatherIndex)的\(items[fatherIndex])，左孩子是在\(maxChildIndex)")
        
        // 比较左右孩子并找出比较大的下标
        if maxChildIndex < endIndex &&
            items[maxChildIndex-1] < items[maxChildIndex] {
            
            print("因为\(maxChildIndex-1)的\(items[maxChildIndex-1])小于\(maxChildIndex)的 \(items[maxChildIndex])\n修正左孩子\(maxChildIndex)为\(maxChildIndex+1)")
            
            maxChildIndex = maxChildIndex + 1
        }
        
        // 如果较大的那个子节点比根节点大，就将该节点的值赋给父节点
        if temp < items[maxChildIndex-1] {
            print("因为取出的\(temp)小于在\(maxChildIndex-1)的\(items[maxChildIndex-1])")
            print("在\(fatherIndex-1)的\(items[fatherIndex-1]) 赋值为在\(maxChildIndex-1)的\(items[maxChildIndex-1])")
            items[fatherIndex-1] = items[maxChildIndex-1]
            print(items)
        } else {
            print("结束循环 因为\(temp)不小于\(items[maxChildIndex-1])")
            break
        }
        
        fatherIndex = maxChildIndex
        maxChildIndex = 2 * fatherIndex
    }
    
    items[fatherIndex-1] = temp
    print("最后在\(fatherIndex-1)的\(items[fatherIndex-1])修改为\(temp)")
    
    print("本轮结束", items)
}

func heapSort(items: [Int]) -> [Int] {
    var list = items
    var endIndex = items.count - 1
    heapCreate(items: &list)
    
    print("创建结束")
    
    while endIndex > 0 {
        let temp = list[0]
        list[0] = list[endIndex]
        list[endIndex] = temp
        endIndex -= 1
        heapAdjast(items: &list, startIndex: 0, endIndex: endIndex + 1)
    }
    return list
}

//var heapList = testList
//print("堆排序开始", heapList)
//print("堆排序", heapSort(items: heapList))

// 桶排序 O(n)

func bucketSort(arr: inout [Int], _ max: Int) -> [Int] {
    // 创建空桶
    var a = [Int](repeating: 0, count: max + 1)
    
    for num in arr {
        if a[num] >= 0 {
            a[num] = a[num] + 1
        }
    }
    
    var sort = [Int]()
    for i in 0..<a.count {
        if a[i] > 1 {
            for _ in 0..<a[i] {
                sort.append(i)
            }
        } else if a[i] > 0 {
            sort.append(i)
        }
    }
    
    return sort
}

//var bucketList = testList
//print("桶排序开始", bucketList)
//print("桶排序", bucketSort(arr: &bucketList, bucketList.max()!))
