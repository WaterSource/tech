//: [Previous](@previous)

import Foundation

let nums = [2, 2, 3]

func maxProfit(_ prices: [Int]) -> Int {
    guard prices.count > 1 else {
        return 0
    }
    
    var startIndex: Int? = nil
    var result = 0
    
    for i in 0..<prices.count {
        
        if ((i == 0 && prices[i+1] > prices[i]) ||
            (i != 0 && i != prices.count-1 && prices[i-1] >= prices[i] && prices[i+1] >= prices[i])) {
            // 买入点
            print("发现买入点\(i)-\(nums[i])")
            if startIndex == nil {
                print("执行买入\(i)-\(nums[i])")
                startIndex = i
            }
        }
        
        if ((i == prices.count-1 && prices[i-1] < prices[i]) ||
            (i != 0 && i != prices.count-1 && prices[i-1] <= prices[i] && prices[i+1] <= prices[i])) {
            // 卖出点
            print("发现卖出点\(i)-\(nums[i])")
            if let start = startIndex {
                print("执行卖出\(i)-\(nums[i])")
                result += (prices[i] - prices[start])
                startIndex = nil
            }
        }
    }
    
    return result
}

maxProfit(nums)

//: [Next](@next)
