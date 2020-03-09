//: [Previous](@previous)

import Foundation

func mergeSort(list: [Int]) -> [Int] {
    var tmp = list
    var helper = tmp
    
    mergeSortHelper(list: &tmp, helper: &helper, left: 0, right: tmp.count-1)
    return tmp
}

func mergeSortHelper(list: inout [Int], helper: inout [Int], left: Int, right: Int) {
    guard left < right else {
        return
    }
    
    let mid = left + (right-left)/2
    
    mergeSortHelper(list: &list, helper: &helper, left: left, right: mid)
    mergeSortHelper(list: &list, helper: &helper, left: mid+1, right: right)
    
    mergeHeler(list: &list, helper: &helper, left: left, mid: mid, right: right)
}

func mergeHeler(list: inout [Int], helper: inout [Int], left: Int, mid: Int, right: Int) {
    
    // 拷贝一份到辅助空间
    for index in left...right {
        helper[index] = list[index]
    }
    
    var helperLeft = left
    var helperRight = mid + 1
    
    var current = left
    
    // 二路归并
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
    
    guard helperLeft <= mid else {
        return
    }
    
    // 左侧队列还有剩余
    for index in 0...(mid-helperLeft) {
        list[current+index] = helper[helperLeft+index]
    }
}

//: [Next](@next)
