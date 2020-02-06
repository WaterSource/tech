//: [Previous](@previous)

import Foundation

// 滑动窗口，用map储存字符和最后出现的位置；
// 右侧逐步增大，如果是一个已经出现过的字符，左侧取 这个字符最后出现的位置 和 原左侧 的最大值

func lengthOfLongestSubstring(_ s: String) -> Int {
    var result = 0
    var left = 0
    
    var hashMap = [String: Int]()
    
    for (index, obj) in s.enumerated() {
        let objStr = String(obj)
        
        if let tmpIndex = hashMap[objStr] {
            left = max(left, tmpIndex)
        }
        
        result = max(result, index - left + 1)
        hashMap[objStr] = index + 1
    }
    
    return result
}

let input = ""
let output = lengthOfLongestSubstring(input)
print(output)

//: [Next](@next)
