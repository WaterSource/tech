//: [Previous](@previous)

import Foundation

//必须在原数组上操作，不能拷贝额外的数组。
//尽量减少操作次数。

var nums1 = [0, 1, 0, 3, 12]
var nums2 = [0, 0, 0, 0, 0]

func moveZeroes(_ nums: inout [Int]) {
    guard nums.contains(0) else {
        return
    }
    
    for i in 0..<nums.count {
        let tmp = nums.count-1-i
        if nums[tmp] == 0 {
            nums.remove(at: tmp)
            nums.append(0)
        }
    }
}

moveZeroes(&nums1)
moveZeroes(&nums2)

//: [Next](@next)
