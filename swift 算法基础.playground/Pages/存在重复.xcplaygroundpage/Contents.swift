//: [Previous](@previous)

import Foundation

let nums = [1, 2, 0, 4]

func containsDuplicate(_ nums: [Int]) -> Bool {
    var numsSet = Set<Int>()
    
    for num in nums {
        if !numsSet.insert(num).inserted {
            return true
        }
    }
    
    return false
    
//    guard nums.count > 1 else {
//        return false
//    }
//    
//    var tmpDic = [Int: Int]()
//    for i in nums {
//        if tmpDic[i] == nil {
//            tmpDic[i] = i
//        } else {
//            return true
//        }
//    }
//
//    return false
}

containsDuplicate(nums)

//: [Next](@next)
