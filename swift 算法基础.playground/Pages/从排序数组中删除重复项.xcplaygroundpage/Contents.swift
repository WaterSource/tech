//: [Previous](@previous)

import Foundation

var nums = [0,0,1,1,1,2,2,3,3,4]

func removeDuplicates(_ nums: inout [Int]) -> Int {
    guard nums.count > 0 else {
        return 0
    }
    
    var index: Int = 0
    for i in 0..<nums.count {
        if nums[i] != nums[index] {
            index += 1
            nums[index] = nums[i]
        }
    }
    return index + 1
}

removeDuplicates(&nums)
