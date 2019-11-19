//: [Previous](@previous)

import Foundation

class TreeNode {
    var val: Int?
    var left: TreeNode?
    var right: TreeNode?
    
    init(_ val: Int?) {
        self.val = val
    }
}

func createTree(_ datasource: [Int?], _ index: inout Int) -> TreeNode? {
    index += 1
    
    if index < datasource.count {
        let item = datasource[index]
        
        if let item = item {
            let note = TreeNode(item)
            note.left = createTree(datasource, &index)
            note.right = createTree(datasource, &index)
            return note
        } else {
            return nil
        }
    }
    return nil
}



var startIndex = -1
let testTree = createTree([1, 2, 3, nil, nil, 4, nil, nil, 2, 4, nil, nil, 3], &startIndex)

func levelorder(_ root: TreeNode?) -> [[Int]] {
    guard let _ = root else {
        return []
    }
    
    var result = [[Int]]()
    var queue = [TreeNode]()
    
    queue.append(root!)
    
    while !queue.isEmpty {
        let size = queue.count
        var list = [Int]()
        
        for _ in 0..<size {
            let node: TreeNode = queue.removeFirst()
            list.append(node.val!)
            
            if node.left != nil {
                queue.append(node.left!)
            }
            
            if node.right != nil {
                queue.append(node.right!)
            }
        }
        
        result.append(list)
    }
    
    return result
}

levelorder(testTree)

//: [Next](@next)
