//: [Previous](@previous)

import Foundation

/*
 思路一 暴力解法 时间O(n*n*n) 空间O(1)
 2级遍历，找到所有的子串的的可能
 再用一次循环，检查是否为回文子串
 
 思路二 优化1 时间O(n*n*n) 空间O(1)
 在思路一的基础上减少循环次数
 第一级遍历，到 s.length-(result.length) 停止，后续的不会更长
 第二级遍历，从后往前遍历，找到即停
 
 思路三 动态规划 时间O(n*n*n) 空间O(n*n)
 定义一个二维数组，记录所有x,y的长度
 状态定义
 f(x,y)表示区间[x,y]范围内所能取到的最长回文子串的长度
 状态转移
 如果[x,y]范围的子串是回文子串，那么f(x,y)=y-x+1
 如果[x,y]范围的子串不是回文子串，那么f(x,y)=max(f(x+1,y),f(x,y-1))
 查找时需要注意从右下角向左上角查询
 
 思路四 动态规划
 定义二维数组，记录[x,y]是否是回文子串
 状态定义
 f(x,y)表示[x,y]范围内的子串是否是回文子串
 状态转移
 如果[x+1,y-1]范围内的子串是回文子串，且s[x]=s[y]，f(x,y)是回文子串
 查找从右上角向下左角查询
 
 leetcode 优秀回答
 Manacher算法
 https://www.cnblogs.com/mini-coconut/p/9074315.html
 */

func longestPalindromeB(_ s: String) -> String {
    if(s.count < 1){
        return s
    }
    let sMap = s.map{String.init($0)}
    let str = "#" + sMap.joined(separator: "#") + "#" // 插入“#”
    let strLen = str.count
    let arr = Array(str)  //转为数组，便于寻址
    
    // 表示z以arr[i]为中心的最长回文子串的最右字符
    // 到 arr[i]的长度
    // 因为arr已经是加了分隔符的，所以来自原数组的长度刚好是(p[i]-1)
    var p = [Int](repeating: 0, count: strLen)
    
    // 之前计算中最长回文子串的右端点最大值
    var maxRight = 0
    // maxRight对应在arr的位置
    var center = 0
    
    var maxLen = 1
    var start = 0
    
    for i in 0..<strLen {
        print("当前是第\(i)轮")
        
        if i < maxRight {
            // 对于center的对称点
            let mirror = 2 * center - i
            p[i] = min(maxRight - i, p[mirror])
            
            print("因为 i:\(i) < maxRight:\(maxRight)")
            print("mirror: \(mirror), p[mirror]: \(p[mirror])")
            print("p[i] = \(p[i])")
        }
        
        var left = i - (p[i] + 1)
        var right = i + (p[i] + 1)
        
        print("left: \(left), right: \(right), p[i]: \(p[i])")
        
        // 以i为中心 探索最长子串
        while (left >= 0 && right < strLen && arr[left] == arr[right]) {
            left -= 1
            right += 1
            p[i] += 1
        }
        
        print("left: \(left), right: \(right), p[i]: \(p[i])")
        
        // 说明以i为中心的回文子串 比之前的要长
        if i+p[i] > maxRight {
            print("因为 i+p[i] > maxRight, \(i+p[i]) > \(maxRight)")
            maxRight = i + p[i]
            center = i
            print("maxRight: \(maxRight), center: \(center)")
        }
        
        // 更新最长半径
        if p[i] > maxLen {
            print("因为 p[i] > maxLen, \(p[i]) > \(maxLen)")
            maxLen = p[i]
            start = (i-maxLen)/2
            print("maxLen: \(maxLen), start: \(start)")
        }
    }
    
    p
    sMap
    
    return Array(sMap[start..<start+maxLen]).joined()
}

let test1 = "qwecbabcty"
let output2 = longestPalindromeB(test1)
output2

func longestPalindrome(_ s: String) -> String {
    guard s.count > 1 else {
            return s
        }
    
        let size = s.count
        var isPalind = [[Bool?]](repeating: [Bool?](repeating: nil, count: size), count: size)
    
        var left = 0
        var right = 0
    
        for leftIndex in (0...size-2).reversed() {
            isPalind[leftIndex][leftIndex] = true
        
            for rightIndex in (leftIndex+1)..<size {
            
                let isSame = String(s[s.validIndex(leftIndex)]) == String(s[s.validIndex(rightIndex)])
                // 两端相等
                if isSame {
                    if rightIndex - leftIndex < 3 {
                        // 长度为3 aba样式
                        isPalind[leftIndex][rightIndex] = true
                    } else if let palind = isPalind[leftIndex+1][rightIndex-1],
                        palind {
                        // 上一组是回文
                        isPalind[leftIndex][rightIndex] = true
                    }
                }
            
                if let palind = isPalind[leftIndex][rightIndex],
                    palind,
                    right - left < rightIndex - leftIndex {
                    left = leftIndex
                    right = rightIndex
                }
            }
        }
    
        return String(s[(s.validIndex(left))...(s.validIndex(right))])
}

extension String {
    func validIndex(_ original: Int) -> String.Index {
        let someNew = String.Index(utf16Offset: original, in: self)
        let someOld = String.Index(encodedOffset: original)
        return someNew
    }
}


func checkStringPalindrome(_ str: String) -> Bool {
    
    let strList = Array(str)
    var index = 0
    
    while index < str.count - 1 - index {
        if strList[index] != strList[str.count - 1 - index] {
            return false
        }
        
        index += 1
    }
    
    return true
}

let test = "daabcbaeac"
let output = longestPalindrome(test)
output

//: [Next](@next)
