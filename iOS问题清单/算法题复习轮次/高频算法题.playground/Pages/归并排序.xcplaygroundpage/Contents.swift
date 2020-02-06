//: [Previous](@previous)

import Foundation

// 分为自顶向下(递归)，自底向上(循环)
// 需要一个同等空间的数组，用于储存合并操作的数组
// 归并实现

// 递归

func mergeSort(_ list: [Int]) -> [Int] {
    var tmp = list
    var helper = tmp
    
    mergeSortHelper(&tmp, &helper, 0, list.count-1)
    return tmp
}

func mergeSortHelper(_ list: inout [Int], _ helper: inout [Int], _ left: Int, _ right: Int) {
    
    guard left < right else {
        return
    }
    
    let mid = (right - left) / 2 + left
    mergeSortHelper(&list, &helper, left, mid)
    mergeSortHelper(&list, &helper, mid + 1, right)
    mergeSortMerge(&list, &helper, left, mid, right)
}

func mergeSortMerge(_ list: inout [Int], _ helper: inout [Int], _ left: Int, _ mid: Int, _ right: Int) {
    
    // 将两个有序序列合并
    for index in left...right {
        helper[index] = list[index]
    }
    
    // 左开头
    var helperLeft = left
    // 右开头
    var helperRight = mid + 1
    
    // 当前指针
    var current = left
    
    while helperLeft <= mid, helperRight <= right {
        let leftItem = helper[helperLeft]
        let rightItem = helper[helperRight]
        
        if leftItem < rightItem {
            list[current] = leftItem
            helperLeft += 1
        } else {
            list[current] = rightItem
            helperRight += 1
        }
        current += 1
    }
    
    // 右侧的已经在队尾，已经有序完成合并
    // 左侧的如果没有完成，插入队尾
    guard helperLeft <= mid else {
        return
    }
    
    for index in 0...(mid-helperLeft) {
        list[current+index] = helper[helperLeft+index]
    }
}

// 循环

func mergeSortB(_ list: [Int]) -> [Int] {
    var tmp = list
    
    var wid = 1
    while wid < list.count {
        mergePassB(&tmp, wid)
        wid *= 2
    }
    
    return tmp
}

func mergePassB(_ list: inout [Int], _ wid: Int) {
    var i = 0
    let count = list.count
    
    // 成对循环
    while i + 2 * wid - 1 < count {
        mergeArray(&list, i, i + wid - 1, i + 2 * wid - 1)
        i += 2 * wid
    }
    
    // 合并剩余的序列
    if i + wid - 1 < count {
        mergeArray(&list, i, i + wid - 1, count - 1)
    }
}

func mergeArray(_ arr: inout [Int], _ low: Int, _ mid: Int, _ high: Int) {
    var i = low
    var j = mid + 1
    var k = 0
    
    var tmpArr = [Int](repeating: 0, count: high - low + 1)
    
    while i <= mid, j <= high {
        if arr[i] < arr[j] {
            tmpArr[k] = arr[i]
            i += 1
            k += 1
        } else {
            tmpArr[k] = arr[j]
            j += 1
            k += 1
        }
    }
    
    while i <= mid {
        tmpArr[k] = arr[i]
        k+=1
        i+=1
    }
    while j <= high {
        tmpArr[k] = arr[j]
        k+=1
        j+=1
    }
    
    // 将排序好的序列复制回原数组
    k=0
    for i in low...high {
        arr[i] = tmpArr[k]
        k+=1
    }
}

// 优化归并
// 1. 对小规模子数组使用插入排序
// 2. 测试待排序序列中左右半边是否已经有序，增加 a[mid] <= a[mid+1] 判断，避免合并操作
// 3. 多线程实现递归部分，左右子序列的在子线程实现，合并操作需要等待后共同完成


// test

let list = [4, 6, 1, 3, 2, 7, 9, 5]
let result = mergeSort(list)
result

//: [Next](@next)
