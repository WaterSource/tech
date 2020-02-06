//: [Previous](@previous)

import Foundation

func maxProfit(_ prices: [Int]) -> Int {
    guard prices.count > 1 else {
        return 0
    }
    
    var maxPrice = 0
    var minPrice = prices[0]
    
    for index in 1..<prices.count {
        let price = prices[index]
        if price < minPrice {
            minPrice = price
        } else {
            maxPrice = max(maxPrice, price - minPrice)
        }
    }
    return maxPrice
}

maxProfit([7, 6, 4, 3, 1])

//: [Next](@next)
