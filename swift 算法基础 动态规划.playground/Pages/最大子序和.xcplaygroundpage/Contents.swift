//: [Previous](@previous)

import Foundation

func maxSubArray(_ nums: [Int]) -> Int {
    guard nums.count > 0 else {
        return 0
    }
    
    guard nums.count > 1 else {
        return nums[0]
    }
    
    var result: Int = nums[0]
    
    var list = [Int](repeating: 0, count: nums.count)
    list[0] = nums[0]
    
    for index in 1..<nums.count {
        if list[index-1] > 0 {
            list[index] = list[index - 1] + nums[index]
        } else {
            list[index] = nums[index]
        }
        result = max(result, list[index])
    }
    return result
}

//let test1 = [-2,1,-3,4,-1,2,1,-5,4]
let test1 = [-2,-1]
maxSubArray(test1)

//: [Next](@next)
