//: [Previous](@previous)

import Foundation

func reverseBits(_ n: UInt32) -> UInt32 {
    var tmp: UInt32 = 0
    var n_copy = n
    
    for _ in 0..<32 {
        tmp<<=1
        tmp = tmp|(n_copy & 1)
        n_copy >>= 1
    }
    return tmp
}

//: [Next](@next)
