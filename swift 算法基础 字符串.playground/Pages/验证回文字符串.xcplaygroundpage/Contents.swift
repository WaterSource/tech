//: [Previous](@previous)

import Foundation

let str1 = "A man, a plan, a canal: Panama"
let str2 = "race a car"
let str3 = " "

func isPalindrome(_ s: String) -> Bool {
    
    var list = [Character]()
    
    for c in s.lowercased() {
        if c.isASCII, let value = c.asciiValue {
            if (value >= 97 && value <= 122) ||
                (value >= 48 && value <= 57) {
                list.append(c)
            }
        }
    }
    
    print(list)
    let sList = Array(list.reversed())
    print(sList)
    
    if list == sList {
        return true
    }
    
    return false
}

//isPalindrome(str1)
isPalindrome(str2)
//isPalindrome(str3)

//: [Next](@next)
