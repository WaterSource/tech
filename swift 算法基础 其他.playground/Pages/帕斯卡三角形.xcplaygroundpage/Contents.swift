//: [Previous](@previous)

import Foundation

/*
 [
 [1],
 [1,1],
 [1,2,1],
 [1,3,3,1],
 [1,4,6,4,1]
 ]
 */

func generate(_ numRows: Int) -> [[Int]] {
    
    guard numRows > 0 else {
        return []
    }
    
    var result = [[Int]]()
    result.append([1])
    
    if numRows == 1 {
        return result
    }
    
    result.append([1, 1])
    
    if numRows == 2 {
        return result
    }
    
    for _ in 3...numRows {
        let last_sub = result.last!
        var sub_result = [Int]()
        
        sub_result.append(1)
        for tmp in 1..<last_sub.count {
            let last1 = last_sub[tmp-1]
            let last2 = last_sub[tmp]
            sub_result.append(last1+last2)
        }
        sub_result.append(1)
        
        result.append(sub_result)
    }
    return result
}

//: [Next](@next)
