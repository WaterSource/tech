//: [Previous](@previous)

import Foundation

func countPrimes(_ n: Int) -> Int {
    guard n > 1 else {
        return 0
    }
    
    var count = 0
    var list = [Bool](repeating: false, count: n)
    
    for index in 2..<n {
        if !list[index] {
            count += 1
            print(index)
            
            var tmp = 1
            while tmp * index < n {
                list[tmp*index] = true
                tmp += 1
            }
        }
    }
    
    return count
}

countPrimes(2)

//: [Next](@next)
