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

// 查验二叉树
// 左<根<右

func isValidBST(_ root: TreeNode?) -> Bool {
    return isValidBST(root, 0, right: LONG_MAX)
}

func isValidBST(_ root: TreeNode?, _ left: Int, right: Int) -> Bool {
    guard let root = root else {
        return true
    }
    
    // 可以修改这个条件来扩展为 左<=根<右
    if root.val! <= left || root.val! >= right {
        return false
    }
    
    return isValidBST(root.left, left, right: root.val!) && isValidBST(root.right, root.val!, right: right)
}

// 因为不是左<=根，所以可以使用中序遍历来查验
// 中序遍历 左-中-右
func isValidBST2(_ root: TreeNode?) -> Bool {
    if root == nil {
        return true
    }
    
    var result = [Int]()
    inorder(root, &result)
    for i in 0..<result.count - 1 {
        if result[i] >= result[i+1] {
            return false
        }
    }
    return true
}

func inorder(_ root: TreeNode?, _ result: inout [Int]) {
    guard let _ = root else {
        return
    }
    
    inorder(root?.left, &result)
    result.append(root!.val!)
    inorder(root?.right, &result)
}

var startIndex = -1
let testTree = createTree([2, 1, nil, nil, 3], &startIndex)

isValidBST(testTree)

//: [Next](@next)
