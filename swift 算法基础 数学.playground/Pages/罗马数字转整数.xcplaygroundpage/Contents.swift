//: [Previous](@previous)

import Foundation

/*
 字符          数值
 I             1
 V             5
 X             10
 L             50
 C             100
 D             500
 M             1000
 */

func romanToInt(_ s: String) -> Int {
    let dic: [String: Int] = ["I":1, "V":5, "X":10, "L":50, "C":100, "D":500, "M":1000]
    
    let list = Array(s)
    var tmp_result = [Int]()
    var result: Int = 0
    
    for index in 0..<list.count {
        let subStr = String(list[index])
        print(subStr)
        if let num = dic[subStr] {
            print(num)
            
            if let last = tmp_result.last,
                last < num {
                result -= last*2
            }
            
            result += num
            tmp_result.append(num)
            
            print(result)
        }
    }
    return result
}

let test1 = "MCMXCIV"
romanToInt(test1)

//: [Next](@next)
