//: [Previous](@previous)

import Foundation

let nums1 = [1, 2, 9, 9]
let nums2 = [9, 9]

func plusOne(_ digits: [Int]) -> [Int] {
    
    var nums = Array(digits.reversed())
    for i in 0..<nums.count {
        let tmp = nums[i] + 1
        if tmp > 9 {
            nums[i] = 0
            if i == nums.count-1 {
                nums.append(1)
            }
        } else {
            nums[i] = tmp
            break
        }
    }
    
    return nums.reversed()
}

plusOne(nums1)
plusOne(nums2)

//: [Next](@next)
