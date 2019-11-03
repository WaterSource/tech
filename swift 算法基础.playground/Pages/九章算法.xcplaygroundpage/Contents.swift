//: [Previous](@previous)

import Foundation

func climbStairs(stairs: Int) -> Int {
    var dp = [Int](repeating: 0, count: stairs+1)
    dp[0] = 1
    dp[1] = 1
    dp[2] = 2
    
    for i in 3...stairs {
        dp[i] = dp[i-1] + dp[i-2]
    }
    
    print(dp)
    
    return dp[stairs]
}

climbStairs(stairs: 4)

//: [Next](@next)
