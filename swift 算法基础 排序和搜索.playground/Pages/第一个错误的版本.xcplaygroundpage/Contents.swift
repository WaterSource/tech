//: [Previous](@previous)

import Foundation

func isBadVersion(_ version: Int) -> Bool {
    if version >= 1 {
        return true
    }
    return false
}

func firstBadVersion(_ n: Int) -> Int {
    if !isBadVersion(n) {
        return -1
    }
    
    var start = 1
    var end = n
    var tmp = -1
    
    if isBadVersion(start) {
        return start
    }
    
    if end - start == 1 {
        return isBadVersion(start) ? start : end
    } else {
        while end - start > 1 {
            tmp = ((end - start) / 2) + start
            print("开始\(start),结束\(end)")
            print("检查\(tmp)")
            if isBadVersion(tmp) {
                end = tmp
            } else {
                start = tmp
            }
            print("结束时 start=\(start),end=\(end),tmp=\(tmp)")
        }
        
        return end
    }
}

firstBadVersion(3)

func firstBadVersionB(_ n: Int) -> Int {
    var start = 1
    var end = n
    var tmp: Int
    
    while start <= end {
        tmp = start + (end - start) / 2
        if isBadVersion(tmp) {
            if tmp == 1 || (!isBadVersion(tmp-1)) {
                return tmp
            } else {
                end = tmp - 1
            }
        } else {
            start = tmp + 1
        }
    }
    return -1
}

//: [Next](@next)
