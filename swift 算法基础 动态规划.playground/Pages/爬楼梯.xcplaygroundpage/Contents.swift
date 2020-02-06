//: [Previous](@previous)

import Foundation

func climbStairs(_ n: Int) -> Int {
    guard n > 0 else {
        return 0
    }
    
    var tmp = [Int: Int]()
    
    tmp[1] = 1
    tmp[2] = 2
    
    if n < 3 {
        return tmp[n]!
    }
    
    for i in 3...n {
        tmp[i] = tmp[i-1]! + tmp[i-2]!
    }
    
    return tmp[n]!
}

climbStairs(10)

//: [Next](@next)
