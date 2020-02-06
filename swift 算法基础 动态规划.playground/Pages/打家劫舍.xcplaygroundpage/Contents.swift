//: [Previous](@previous)

import Foundation

func rob(_ nums: [Int]) -> Int {
    
    guard nums.count > 0 else {
        return 0
    }
    
    if nums.count == 1 {
        return nums[0]
    }
    
    if nums.count == 2 {
        return max(nums[0], nums[1])
    }
    
    var list = [Int](repeating: 0, count: nums.count)
    list[0] = nums[0]
    list[1] = max(nums[0], nums[1])
    
    for index in 2..<nums.count {
        list[index] = max(list[index - 1], list[index - 2] + nums[index])
    }
    
    return list.last!
}

let test1 = [0]
rob(test1)

//: [Next](@next)
