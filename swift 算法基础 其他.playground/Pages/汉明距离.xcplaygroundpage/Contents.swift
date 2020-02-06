//: [Previous](@previous)

import Foundation

/*
 var num = 0
 var tmp = n
 
 while tmp != 0 {
 tmp = tmp&(tmp-1)
 num += 1
 }
 return num
 */

func hammingDistance(_ x: Int, _ y: Int) -> Int {
    
    var tmp = x^y
    var count = 0
    
    while tmp != 0 {
        tmp = tmp&(tmp-1)
        count += 1
    }
    return count
}

//: [Next](@next)
