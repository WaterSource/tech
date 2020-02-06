//: [Previous](@previous)

import Foundation

func isValid(_ s: String) -> Bool {
    guard !s.isEmpty else {
        return true
    }
    
    let dic = [")":"(", "}":"{", "]":"["]
    
    var stack = [String]()
    
    for c in s {
        let tmp = String(c)
        if let left = dic[tmp] {
            if left == stack.last {
                stack.removeLast()
            } else {
                return false
            }
        } else {
            stack.append(tmp)
        }
    }
    
    return stack.isEmpty
}

isValid("({)}[]")

//: [Next](@next)
