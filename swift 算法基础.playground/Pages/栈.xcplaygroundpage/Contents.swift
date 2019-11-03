//: [Previous](@previous)

import Foundation

var sentence = "The quick brown fox jumped over the lazy dog."

class Stack {
    var stack: [AnyObject]
    var isEmpty: Bool {return stack.isEmpty}
    var peek: AnyObject? {return stack.last}
    
    init() {
        stack = [AnyObject]()
    }
    
    func push(object: AnyObject) {
        stack.append(object)
    }
    
    func pop() -> AnyObject? {
        if (!isEmpty) {
            return stack.removeLast()
        } else {
            return nil
        }
    }
}

// 例题
// 给出指定值，在列表中找到两个数相加等于指定值

func twoSum(nums: [Int], _ target: Int) -> Bool {
    var set = Set<Int>()
    
    for num in nums {
        if set.contains(target - num) {
            return true
        }
        set.insert(num)
    }
    
    return false
}

// 只有唯一解，找到相加数的位置

func twoSum(nums: [Int], _ target: Int) -> (firstIndex: Int, secondIndex: Int)? {
    var dic = [Int:Int]()
    
    for (index, num) in nums.enumerated() {
        
        if let result = dic[target-num] {
            return (result, index)
        }
        
        dic[num] = index
    }
    
    return nil
}

// 例题
// 输出路径的最后文件夹名，其中".."存在含义

func simplifyPath(path: String) -> String {
    // 用数组来实现栈
    var pathStack = [String]();
    // 拆分原路径
    let paths = path.components(separatedBy: "/")
    
    for obj in paths {
        // 对于"."直接跳过
        guard obj != "." else {
            continue
        }
        
        // 对于".."我们使用pop操作
        if obj == ".." {
            if pathStack.count > 0 {
                pathStack.removeLast()
            }
        } else if obj != "" {
            pathStack.append(obj)
        }
    }
    
    let res = pathStack.reduce("") { total, dir in
        "\(total)/\(dir)"
    }
    
    return res.isEmpty ? "/" : res
}

simplifyPath(path: "a/b/./../c/")

extension Array where Element: Comparable {
    func countUniques() -> Int {
        let sorted = self.sorted(by: <)
        let initial: (Element?, Int) = (.none, 0)
        let reduced = sorted.reduce(initial) { (result, item) -> (Element?, Int) in
            if result.0 == item {
                return (item, result.1)
            } else {
                return (item, result.1 + 1)
            }
        }
        return reduced.1
    }
}

