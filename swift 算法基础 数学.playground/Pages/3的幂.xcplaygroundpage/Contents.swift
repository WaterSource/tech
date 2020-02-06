//: [Previous](@previous)

import Foundation

func isPowerOfThreeA(_ n: Int) -> Bool {
    if n == 1 {
        return true
    }
    
    if n%3 != 0 || n == 0 {
        return false
    }
    
    return isPowerOfThreeA(n/3)
}

isPowerOfThreeA(28)

func isPowerOfThreeB(_ n: Int) -> Bool {
    var tmp = n
    
    if tmp < 1 {
        return false
    }
    
    while tmp%3 == 0 {
        tmp /= 3
    }
    
    return tmp == 1
}

isPowerOfThreeB(27)

//func isPowerOfThreeC(_ n: Int) -> Bool {
//    if n <= 0 {
//        return false
//    }
//    
//    let maxint: Double = Double(INT_MAX)
//    let k: Int = Int(log(maxint) / log(3))
//    let bbb = pow(3, k)
//    return Int(bbb)%n == 0
//}
//
//isPowerOfThreeC(27)

//: [Next](@next)
