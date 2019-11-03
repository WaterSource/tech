//: [Previous](@previous)

import Foundation

func longestCommonPrefix(_ strs: [String]) -> String {
    guard strs.count > 0 else {
        return ""
    }
    
    guard strs.count > 1 else {
        return strs.first!
    }
    
    let list = strs.sorted { $0.count < $1.count }
    
    let firstStrList = Array(list.first!)
    var res = ""
    
    for index in 0..<firstStrList.count {
        let tmp = firstStrList[index]
        
        var isSame = true
        for otherIndex in 1..<list.count {
            
            let otherList = Array(list[otherIndex])
            if otherList[index] != tmp {
                isSame = false
            }
        }
        
        if !isSame {
            return res
        } else {
            res.append(tmp)
        }
    }
    
    return res
}

let test1 = ["flower","flow","flight"]
longestCommonPrefix(test1)

let test2 = ["dog","racecar","car"]
longestCommonPrefix(test2)

let test3 = ["c","c"]
longestCommonPrefix(test3)

func longestCommonPrefixB(_ strs: [String]) -> String {
    if strs.count == 0 {
        return ""
    }
    var commonPrefix = ""
    
    var firstString = strs[0]
    var strings = strs
    strings.removeFirst()
    
    for char in firstString {
        var prefixString = commonPrefix
        prefixString.append(char)
        
        for string in strings {
            if !string.hasPrefix(prefixString) {
                return commonPrefix
            }
        }
        commonPrefix = prefixString
    }
    
    return commonPrefix
}

//: [Next](@next)
