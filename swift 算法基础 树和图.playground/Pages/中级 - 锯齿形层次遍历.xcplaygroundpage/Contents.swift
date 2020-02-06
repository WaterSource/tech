//: [Previous](@previous)

import Foundation

// 锯齿形层级遍历
// 偶数层倒叙

func zigzagLevelOrder(_ root: TreeNode?) -> [[Int]] {
    guard let root = root else {
        return [[Int]]()
    }
    
    var result = [[Int]]()
    
    var stack = [TreeNode]()
    stack.append(root)
    
    var index = 0
    
    while !stack.isEmpty {
        var tmp = [Int]()
        let count = stack.count
        
        index += 1
        
        for _ in 0..<count {
            var item = stack.removeFirst()
            tmp.append(item.val)
            
            if item.left != nil {
                stack.append(item.left!)
            }
            
            if item.right != nil {
                stack.append(item.right!)
            }
        }
        
        if index%2 == 0 {
            tmp = tmp.reversed()
        }
        
        result.append(tmp)
    }
    
    return result
}

let test = TreeNode.createTree([1,2,4,nil,nil,nil,3,nil,5])
let result = zigzagLevelOrder(test)
print(result)

//: [Next](@next)
