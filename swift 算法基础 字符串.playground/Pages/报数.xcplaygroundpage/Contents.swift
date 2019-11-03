//: [Previous](@previous)

import Foundation

func countAndSay(_ n: Int) -> String {
    var start = "1"
    var times = 0
    
    while times < n-1 {
        start = helper(start)
        times += 1
    }
    
    return start
}

func helper(_ str: String) -> String {
    let list = Array(str)
    
    var num = 0
    var tmp: String = ""
    var result = [String]()
    
    for obj in list {
        let current = String(obj)
        
        if current == tmp {
            num += 1
        } else {
            if num != 0, tmp != "" {
                result.append("\(num)\(tmp)")
            }
            
            num = 1
            tmp = current
        }
    }
    
    if num != 0, tmp != "" {
        result.append("\(num)\(tmp)")
    }
    
    return result.joined()
}

let test1 = 1
countAndSay(test1)

let test2 = 2
countAndSay(test2)

let test3 = 3
countAndSay(test3)

let test4 = 4
countAndSay(test4)

//: [Next](@next)
