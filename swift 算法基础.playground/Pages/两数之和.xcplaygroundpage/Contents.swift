//: [Previous](@previous)

import Foundation

let nums = [3, 2, 4]

let target = 6

func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    guard nums.count > 0 else {
        return []
    }
    
    for i in 0..<nums.count {
        let tmp = nums[i]
        let tmpTarget = target - tmp
        
        for j in i+1..<nums.count {
            if nums[j] == tmpTarget {
                return [i, j]
            }
        }
    }
    
    return []
}

twoSum(nums, target)

func twoSumB(_ nums: [Int], _ target: Int) -> [Int] {
    var map = [Int: Int]()
    for (index, value) in nums.enumerated() {
        let com = target - value
        if let tmp = map[com] {
            return [tmp, index]
        }
        map[value] = index
    }
    return []
}

twoSumB(nums, target)

//: [Next](@next)
