//: [Previous](@previous)

import Foundation

var nums = [4, 1, 2, 1, 2]

func singleNumber(_ nums: [Int]) -> Int {
    guard nums.count > 1 else {
        return nums[0]
    }
    
    var result = 0
    for i in nums {
        result ^= i
    }
    
    return result
}

singleNumber(nums)

//: [Next](@next)
