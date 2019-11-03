//: [Previous](@previous)

import Foundation

func strStr(_ haystack: String, _ needle: String) -> Int {
    guard needle.count > 0 else {
        return 0
    }
    
    guard haystack.count >= needle.count else {
        return -1
    }
    
    if haystack == needle {
        return 0
    }
    
    let list1 = Array(haystack)
    let list2 = Array(needle)
    
    for index_i in 0...list1.count - needle.count {
        let value_i = list1[index_i]
        
        if value_i == list2.first {
            var flag = true
            
            for index_j in 1..<list2.count {
                index_i
                index_j
                let tmpIndex = index_i+index_j
                print("当前检索list1第\(tmpIndex)位的\(list1[tmpIndex])")
                print("list2第\(index_j)位的\(list2[index_j])")
                if tmpIndex > list1.count {
                    flag = false
                    break
                }
                if list1[tmpIndex] != list2[index_j] {
                    flag = false
                    break
                }
            }
            if flag {
                return index_i
            }
        }
    }
    
    return -1
}

let haystack1 = "hello", needle1 = "ll"
let haystack2 = "hello", needle2 = "bba"
let haystack3 = "a", needle3 = "a"
let haystack4 = "mississippi", needle4 = "pi"

//strStr(haystack1, needle1)
//strStr(haystack2, needle2)
//strStr(haystack3, needle3)
strStr(haystack4, needle4)

func strStrB(_ haystack: String, _ needle: String) -> Int {
    if needle == "" {
        return 0
    }
    var index = -1
    if let range = haystack.range(of: needle, options: .literal) {
        if !range.isEmpty {
            index = haystack.distance(from: haystack.startIndex, to: range.lowerBound)
        }
    }
    return index
}

//: [Next](@next)
