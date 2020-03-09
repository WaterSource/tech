import UIKit

func quickSort(arr: inout [Int], begin: Int, end: Int) {
    
    guard begin < end else {
        return
    }
    
    // 优化步骤
    swapPviot(arr: &arr, begin: begin, end: end, type: 0)
    
    let pviot = arr[begin]
    
    var left = begin
    var right = end
    
    while left < right {
        while pviot <= arr[right], left < right {
            right -= 1
        }
        while pviot > arr[left], left < right {
            left += 1
        }
        
        if left < right {
            (arr[left], arr[right]) = (arr[right], arr[left])
        }
    }
    
    (arr[begin], arr[left]) = (arr[left], arr[begin])
    
    quickSort(arr: &arr, begin: begin, end: left-1)
    quickSort(arr: &arr, begin: left+1, end: right)
}

func swapPviot(arr: inout [Int], begin: Int, end: Int, type: Int) {
    switch type {
    case 1:
        // 随机取值
        let randomIndex = Int(arc4random())%(end-begin) + begin
        (arr[begin], arr[randomIndex]) = (arr[randomIndex], arr[begin])
    default:
        // 三数取中，目标是找到中位数下标，使得最低位为中位数
        let mid = begin + (end-begin)/2
        if arr[begin] > arr[end] {
            (arr[begin], arr[end]) = (arr[end], arr[begin])
        }
        if arr[mid] > arr[end] {
            (arr[mid], arr[end]) = (arr[end], arr[mid])
        }
        if arr[mid] > arr[begin] {
            (arr[mid], arr[begin]) = (arr[begin], arr[mid])
        }
    }
}
