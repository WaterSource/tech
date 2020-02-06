//: [Previous](@previous)

import Foundation

// 快速找到重复的数

// 异或的思路，局限在数组连续或者知道数组范围
// 1^0=1 1^1=0 0^0=0

func findNum(_ nums: [Int]) -> Int {
    
    var result: Int?
    // 全量异或
    for tmp in nums {
        if let _result = result {
            result = _result^tmp
        } else {
            result = tmp
        }
    }
    
    var compare: Int?
    // 1...9 替代不重复情况下的总值
    for tmp in 1...9 {
        if let _compare = compare {
            compare = _compare^tmp
        } else {
            compare = tmp
        }
    }
    
    return result!^compare!
}

let test = [1, 2, 3, 4, 5, 5, 6, 7, 8]
findNum(test)

//: [Next](@next)
