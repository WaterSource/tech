//: [Previous](@previous)

import Foundation

func missingNumberA(_ nums: [Int]) -> Int {
    
    let tmp = (0...nums.count).reduce(0, +)
    let sum = nums.reduce(0,+)
    
    return tmp-sum
}

missingNumberA([0, 1, 2])

func missingNumberB(_ nums: [Int]) -> Int {
    var result = 0
    for index in 0..<nums.count {
        result ^= (index + 1)^nums[index]
    }
    return result
}

missingNumberB([0, 1, 2])

//: [Next](@next)
