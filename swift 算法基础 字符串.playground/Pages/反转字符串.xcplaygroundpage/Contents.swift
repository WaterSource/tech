//: [Previous](@previous)

import Foundation

var str: [Character] = ["H","a","n","n","a","h"]

func reverseString(_ s: inout [Character]) {
    s.reverse()
}

reverseString(&str)

//: [Next](@next)
