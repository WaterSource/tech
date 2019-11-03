//: [Previous](@previous)

import Foundation

let s1 = "anagram", t1 = "nagaram"
let s2 = "rat", t2 = "car"

func isAnagram(_ s: String, _ t: String) -> Bool {
    
    guard s.count == t.count else {
        return false
    }
    
    let sList = Array(s).sorted()
    let tList = Array(t).sorted()
    
    if sList == tList {
        return true
    }
    
    return false
}

isAnagram(s1, t1)
isAnagram(s2, t2)

func isAnagramB(_ s: String, _ t: String) -> Bool {
    
    guard s.count == t.count else {
        return false
    }
    let offset = Int("a".unicodeScalars.first?.value ?? 0)
    var counter: [Int] = Array(repeating: 0, count: 26)
    for c in s.unicodeScalars {
        counter[Int(c.value) - offset ] += 1
    }
    for c in t.unicodeScalars {
        counter[Int(c.value) - offset] -= 1
    }
    
    return counter == Array(repeating: 0, count: 26)
}

//: [Next](@next)
