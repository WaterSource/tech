//: [Previous](@previous)

import Foundation

class TreeNode {
    var val: String?
    var left: TreeNode?
    var right: TreeNode?
    
    init(_ val: String) {
        self.val = val
    }
}

func createTree(_ datasource: [String], _ index: inout Int) -> TreeNode? {
    index += 1
    
    if index < datasource.count {
        let item = datasource[index]
        
        if item == "" {
            return nil
        } else {
            let note = TreeNode(item)
            note.left = createTree(datasource, &index)
            note.right = createTree(datasource, &index)
            return note
        }
    }
    return nil
}

var startIndex = -1
let testTree = createTree(["a", "b", "d", "", "", "e", "", "", "c", "", "f", "", ""], &startIndex)

func maxDepth(_ root: TreeNode?) -> Int {
    guard let root = root else {
        return 0
    }
    
    return max(maxDepth(root.left), maxDepth(root.right)) + 1
}

maxDepth(testTree)

//: [Next](@next)
