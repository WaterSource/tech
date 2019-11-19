import UIKit

// 冒泡排序 优化版本 鸡尾酒排序
func cocktailSort(_ list: inout [Int]) {
    var begin = 0
    var end = list.count - 1
    
    while begin <= end {
        var newBegin = end
        var newEnd = begin
        
        // 正向循环 把最大元素移动到末尾
        for j in begin..<end {
            if list[j] > list[j+1] {
                (list[j], list[j+1]) = (list[j+1], list[j])
                newEnd = j + 1
            }
        }
        
        end = newEnd - 1
        
        // 逆向循环 把最小元素移动到最前
        for j in (begin...end).reversed() {
            if list[j] > list[j+1] {
                (list[j], list[j+1]) = (list[j+1], list[j])
                newBegin = j
            }
        }
        
        begin = newBegin + 1
    }
}

// 插入排序
// 每次只处理一个元素，从后往前找，找到合适的位置插入。
// 最好的情况，输入为升序，只需要比较n次，不需要移动，时间复杂度为O(n)
// 最坏的情况，输入为逆序，每个元素还需要比较n次，复杂度为O(n*n)
func insertSort(_ list: inout [Int]) {
    var index = 1
    while index < list.count {
        var j = index
        while j > 0 && list[j-1] > list[j] {
            (list[j], list[j-1]) = (list[j-1], list[j])
            j -= 1
        }
        index += 1
    }
}

// 快速排序
// 在数组中选择基准值，和基准值比较大小，小的放在基准左侧，打的放在基准右侧
func quickSort(arr: inout [Int], begin: Int, end: Int) {
    guard begin < end else {
        return
    }
    
    var left = begin
    var right = end
    
    // 基准值
    let pivot = arr[left]
    
    while left < right {
        // 因为基准值取得最左，必须先从最右找起
        
        // 从右向左找第一个小于基准值的值
        while pivot <= arr[right], left < right {
            right -= 1
        }
        
        // 从左向右找第一个大于基准值的值
        while arr[left] <= pivot, left < right {
            left += 1
        }
        
        if left < right {
            (arr[left], arr[right]) = (arr[right], arr[left])
        }
    }
    
    (arr[begin], arr[left]) = (arr[left], arr[begin])
    
    quickSort(arr: &arr, begin: begin, end: left-1)
    quickSort(arr: &arr, begin: right+1, end: end)
}

// 归并排序
// 分治法，分为若干个子序列，分别对子序列排序，最后合并
func mergeSort(_ array: inout [Int], _ helper: inout [Int], _ low: Int, _ high: Int) {
    guard low < high else {
        return
    }
    
    // 中间数
    let middle = (high - low) / 2 + low
    mergeSort(&array, &helper, low, middle)
    mergeSort(&array, &helper, middle+1, high)
    merge(&array, &helper, low, middle, high)
}

func merge(_ array: inout [Int], _ helper: inout [Int], _ low: Int, _ middle: Int, _ high: Int) {
    
    for i in low...high {
        helper[i] = array[i]
    }
    
    // 左边子序列开头
    var helperLeft = low
    // 右边子序列开头
    var helperRight = middle + 1
    // 当前指针位
    var current = low
    
    while helperLeft < middle && helperRight <= high {
        // 合并左右序列
        if helper[helperLeft] <= helper[helperRight] {
            array[current] = helper[helperLeft]
            helperLeft += 1
        } else {
            array[current] = helper[helperRight]
            helperRight += 1
        }
        
        current += 1
    }
    
    // 如果是左边子序列没用完，把剩下的值完成赋值
    guard middle - helperLeft >= 0 else {
        return
    }
    
    for i in 0...(middle-helperLeft) {
        array[current + i] = helper[helperLeft + i]
    }
}
