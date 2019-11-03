//: [Previous](@previous)

import Foundation

var names = "Tom Smith"
var sentence = "The quick brown fox jumped over the lazy dog."

func allPrefixed1(str: String) -> [Substring] {
    return(0...str.count).map(str.prefix)
}

func allPrefixed2(str: String) -> [Substring] {
    return [""] + str.indices.map({index in str[...index]})
}

//print(allPrefixed2(str: names))

extension String {
    // 到达指定个数换行
    func wrapped(after: Int = 70) -> String {
        var i = 0
        let lines = self.split(omittingEmptySubsequences: false) {
            character in
            switch character {
            case "\n",
                 " " where i >= after:
                i = 0
                return true
            default:
                i += 1
                return false
            }
        }
        return lines.joined(separator: "\n")
    }
    
    // 指定位数是否正确
    func validIndex(original: Int) -> String.Index {
        switch original {
        case ...startIndex.encodedOffset:
            return startIndex
        case endIndex.encodedOffset...:
            return endIndex
        default:
            return index(startIndex, offsetBy: original)
        }
    }
}

// 在字符串中找到字符串的位置
func findStr(targetStr: String, isIn originStr: String) -> Int {
    guard originStr.count != 0, originStr.count >= targetStr.count else {
        return -1
    }
    
    for i in 0...originStr.count - targetStr.count {
        
        let tmpStrIndex = originStr.index(originStr.startIndex, offsetBy: i, limitedBy: originStr.endIndex)
        
        guard originStr[tmpStrIndex!] == targetStr[targetStr.startIndex] else {
            continue
        }
        
        for j in 0..<targetStr.count {
            let tmpStrIndex2 = originStr.index(tmpStrIndex!, offsetBy: j, limitedBy: originStr.endIndex)
            let targetTmpIndex = targetStr.index(targetStr.startIndex, offsetBy: j, limitedBy: targetStr.endIndex)
            
            guard let strIndex2 = tmpStrIndex2,
                let targetIndex = targetTmpIndex,
                originStr[strIndex2] == targetStr[targetIndex] else {
                    break
            }
            
            if j == targetStr.count - 1 {
                return i
            }
        }
    }
    
    return -1
}

findStr(targetStr: "Smith", isIn: names)

// 例题
// 给出句子，单词之间只有空格间隔，按单词逆序；不额外增加内存；

func m_reverse<T>(_ chars: inout [T], _ start: Int, _ end: Int) {
    var start = start, end = end
    
    while start < end {
        m_swap(&chars, start, end)
        start += 1
        end -= 1
    }
}

func m_swap<T>(_ chars: inout [T], _ p: Int, _ q: Int) {
    (chars[p], chars[q]) = (chars[q], chars[p])
}

func m_reverseString(s: String?) -> String? {
    guard let s = s else {
        return nil
    }
    
    var chars = Array(s), start = 0
    
    // 整体反转
    m_reverse(&chars, 0, chars.count - 1)
    
    for i in 0..<chars.count {
        // 已经到结尾 下一个字符是空格
        if i == chars.count - 1 || chars[i + 1] == " " {
            
            // 反转单词
            m_reverse(&chars, start, i)
            start = i + 2
        }
    }
    
    return String(chars)
}

let result = m_reverseString(s: sentence)
