//: [Previous](@previous)

import Foundation

// 快速排序的描述
// 通过选择标兵，将数组分为左右两个部分，分别是小于标兵和大于标兵；然后对两个部分重复分区的操作，直到所有子集元素不再需要上述步骤
// 平均运行时间 O(NlogN) 最坏运行时间O(N^2)
// 结果不稳定

// 快排实现

func quickSort(_ list: [Int]) -> [Int] {
    guard list.count > 1 else {
        return list
    }
    
    var tmp = list
    quickSortHelper(&tmp, 0, right: list.count-1)
    return tmp
}

func quickSortHelper(_ list: inout [Int], _ left: Int, right: Int) {
    
    guard left < right else {
        return
    }
    
    let begin = left
    let pviot = list[begin]
    
    var leftIndex = left
    var rightIndex = right
    
    while leftIndex < rightIndex {
        while pviot <= list[rightIndex],
            leftIndex < rightIndex {
            rightIndex -= 1
        }
        while pviot >= list[leftIndex],
            leftIndex < rightIndex {
            leftIndex += 1
        }
        if leftIndex < rightIndex {
            (list[leftIndex], list[rightIndex]) = (list[rightIndex], list[leftIndex])
        }
    }
    (list[begin], list[leftIndex]) = (list[leftIndex], list[begin])
    
    quickSortHelper(&list, left+1, right: leftIndex-1)
    quickSortHelper(&list, leftIndex+1, right: right)
}

let list = [2, 1]
let result = quickSort(list)
result

// 快排的特殊情况
// 最坏情况是对已经排序过的数组再次快排
// 递归存在栈溢出风险，嵌套过深会有效率问题


// 可以选择的优化
// 1 基准的选择，需要避免分隔出的数据都在一侧，花费了时间做大小比较但是没有完成实质排序
// 可以选择三数中值作为基准

// 2 如何移动基准，如果采用三数中值，需要先对这三个值完成排序，基准往移动的时候可以选择 左侧第二位或者右侧第二位

//: [Next](@next)
