//: [Previous](@previous)

import Foundation

let str1 = "yallodlayrrouunnd"
let str2 = "leetcode"
let str3 = "loveleetcode"

func firstUniqChar(_ s: String) -> Int {
    
    let list = Array(s)
    var dic = [String: Int]()
    
    for value in list {
        let str = String(value)
        if let _ = dic[str] {
            dic[str] = -1
        } else {
            dic[str] = 1
        }
    }
    
    for (i, value) in list.enumerated() {
        if dic[String(value)] == 1 {
            return i
        }
    }
    
    return -1
}

firstUniqChar(str1)
firstUniqChar(str2)
firstUniqChar(str3)

//: [Next](@next)
