//: [Previous](@previous)

import Foundation

func maxDepth(_ root: TreeNode?) -> Int {
    guard let root = root else {
        return 0
    }
    
    return max(maxDepth(root.left), maxDepth(root.right)) + 1
}

let testTree = TreeNode.createTree([1,2,3,nil,nil,4,nil,nil,5,nil,6,nil,nil])
print(maxDepth(testTree))

//: [Next](@next)
