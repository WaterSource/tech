//: [Previous](@previous)

import Foundation

// topK
func topK(_ list: [Int], _ k: Int) -> [Int] {
    guard list.count > k else {
        return list
    }
    
    var tmpList = list
    return topKHelper(&tmpList, 0, tmpList.count-1, k)
}

func topKHelper(_ list: inout [Int], _ left: Int, _ right: Int, _ k: Int) -> [Int] {
    
    let pivot = list[left]
    let pivotLoc = left
    
    var leftIndex = left
    var rightIndex = right
    
    while leftIndex < rightIndex {
        // 在右侧找到比标兵大的数
        while pivot >= list[rightIndex],
            leftIndex < rightIndex {
            rightIndex -= 1
        }
        
        // 在左侧找到比标兵小的数
        while list[leftIndex] >= pivot,
            leftIndex < rightIndex {
            leftIndex += 1
        }
        
        if leftIndex < rightIndex {
            (list[leftIndex], list[rightIndex]) = (list[rightIndex], list[leftIndex])
        }
    }
    
    (list[pivotLoc], list[leftIndex]) = (list[leftIndex], list[pivotLoc])
    
    if leftIndex > k - 1 {
        return topKHelper(&list, left, leftIndex-1, k)
    } else if leftIndex < k - 1 {
        return topKHelper(&list, leftIndex+1, right, k)
    } else {
        return Array(list[0..<k])
    }
}

let list = [4,6,1,3,2,7,9,5]
let result = topK(list, 4)
result

//: [Next](@next)
