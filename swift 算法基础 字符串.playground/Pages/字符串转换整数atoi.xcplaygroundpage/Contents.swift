//: [Previous](@previous)

import Foundation

let str1 = "-91283472332"
let str2 = "-2147483647"
let str3 = "4193 with words"
let str4 = "words and 987"
let str5 = "0-1"

func myAtoi(_ str: String) -> Int {
    guard str.count > 0 else {
        return 0
    }
    
    let list = Array(str)
    var result = [Int]()
    var flag: Int = 0
    
    for index in 0..<list.count {
        let obj = list[index]
        if obj.isWhitespace {
            
            if flag != 0 {
                break
            }
            
            if result.isEmpty {
                continue
            } else {
                break
            }
        }
        
        guard let value = obj.asciiValue else {
            return 0
        }
        
        if value == 45 {
            if !result.isEmpty {
                break
            }
            if flag == 0 {
                flag = -1
                continue
            } else {
                return 0
            }
        } else if value == 43 {
            if !result.isEmpty {
                break
            }
            if flag == 0 {
                flag = 1
                continue
            } else {
                return 0
            }
        }
        
        if value < 48 || value > 57 {
            if result.isEmpty {
                return 0
            } else {
                break
            }
        }
        
        result.append(Int(value-48))
    }
    print("当前结果", result)
    
    var vv = 0
    for x in result {
        guard vv < INT32_MAX else {
            if flag <= 0 {
                return Int(-INT32_MAX)-1
            } else {
                return Int(INT32_MAX)
            }
        }
        
        vv *= 10
        vv += x
    }
    
    guard vv <= INT32_MAX else {
        if flag < 0 {
            return Int(-INT32_MAX)-1
        } else {
            return Int(INT32_MAX)
        }
    }
    
    return vv * (flag < 0 ? -1 : 1)
}

//str1
//myAtoi(str1)
//str2
//myAtoi(str2)
//myAtoi(str3)
//myAtoi(str4)

myAtoi(str5)

//: [Next](@next)
