//: [Previous](@previous)

import Foundation

func topK(_ list: [Int], _ k: Int) -> [Int] {
    guard list.count > k else {
        return list
    }
    
    var tmpList = list
    return topKHelper(&tmpList, 0, tmpList.count-1, k)
}

func topKHelper(_ list: inout [Int], _ left: Int, _ right: Int, _ k: Int) -> [Int] {
    
    // 三数取中
    let mid = left + (right - left)/2
    if list[left] > list[right] {
        (list[left], list[right]) = (list[right], list[left])
    }
    if list[mid] > list[right] {
        (list[mid], list[right]) = (list[right], list[mid])
    }
    if list[mid] > list[left] {
        (list[mid], list[left]) = (list[left], list[mid])
    }
    
    let pivotIndex = left
    let pivot = list[pivotIndex]
    
    var leftIndex = left
    var rightIndex = right
    
    while leftIndex < rightIndex {
        while leftIndex < rightIndex,
            list[rightIndex] > pivot {
            rightIndex -= 1
        }
        
        while leftIndex < rightIndex,
            list[leftIndex] <= pivot {
            leftIndex += 1
        }
        
        if leftIndex < rightIndex {
            (list[leftIndex], list[rightIndex]) = (list[rightIndex], list[leftIndex])
        }
    }
    
    (list[pivotIndex], list[leftIndex]) = (list[leftIndex], list[pivotIndex])
    
    if leftIndex > k-1 {
        return topKHelper(&list, left, leftIndex-1, k)
    } else if leftIndex < k-1 {
        return topKHelper(&list, leftIndex + 1, right, k)
    } else {
        return Array(list[0..<k])
    }
}

let list = [4,6,1,3,2,7,9,5]
let result = topK(list, 4)
result

//: [Next](@next)
