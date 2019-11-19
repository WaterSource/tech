import UIKit

// 快速找到重复的数
func findNum(_ nums: [Int]) -> Int {
    
    var result: Int?
    for tmp in nums {
        if let _result = result {
            result = _result^tmp
        } else {
            result = tmp
        }
    }
    
    var compare: Int?
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
