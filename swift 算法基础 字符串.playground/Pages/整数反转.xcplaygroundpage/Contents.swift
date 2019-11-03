//: [Previous](@previous)

import Foundation

let tmp1 = 123
let tmp2 = -123
let tmp3 = 1534236469

func reverse(_ x: Int) -> Int {
    
    var list = [Int]()
    let flag: Bool = x < 0
    var tmp = flag ? -x : x
    
    while tmp > 0 {
        let q = tmp % 10
        list.append(q)
        tmp = tmp / 10
    }
    
    var result = 0
    
    for i in list {
        result *= 10
        result += i
    }
    
    if flag {
        result = -result
    }
    
    if (result < -INT32_MAX) {
        return 0
    } else if (result > INT32_MAX) {
        return 0
    }
    
    return result
}

//reverse(tmp1)
//reverse(tmp2)
reverse(tmp3)

//: [Next](@next)
