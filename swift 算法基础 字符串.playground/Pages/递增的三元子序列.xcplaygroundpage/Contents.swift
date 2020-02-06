//: [Previous](@previous)

import Foundation

func increasingTripletB(_ nums: [Int]) -> Bool {
    guard nums.count > 2 else {
        return false
    }
    
    Int.max
    
    var left: Int = LONG_MAX
    var middle: Int = LONG_MAX
    
    for obj in nums {
        if left >= obj {
            left = obj
        } else if middle >= obj {
            middle = obj
        } else {
            return true
        }
    }
    
    return false
}

func increasingTriplet(_ nums: [Int]) -> Bool {
    guard nums.count > 2 else {
        return false
    }
    
    for index in (0..<nums.count).reversed() {
        var times = 2
        if helper(nums, index, &times) {
            return true
        }
    }
    
    return false
}

func helper(_ nums: [Int], _ maxIndex: Int, _ times: inout Int) -> Bool {
    if times == 0 {
        return true
    }
    times -= 1
    let maxTmp = nums[maxIndex]
    for index in (0..<maxIndex).reversed() {
        let tmp = nums[index]
        if maxTmp > tmp {
            return helper(nums, index, &times)
        }
    }
    return false
}

let input1 = [5,1,5,5,2,5,4]
increasingTripletB(input1)
let input2 = [5, 4, 3, 2, 1]
increasingTripletB(input2)
let input3 = [1, 2, 3, 4, 5]
increasingTripletB(input3)

//: [Next](@next)
