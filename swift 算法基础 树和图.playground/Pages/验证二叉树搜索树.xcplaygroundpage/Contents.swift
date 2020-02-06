//: [Previous](@previous)

import Foundation

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
    guard root.val > left, root.val < right else {
        return false
    }
    
    // 左右子树
    let leftTree = isValidBST(root.left, left, right: root.val)
    let rightTree = isValidBST(root.right, root.val, right: right)
    
    return leftTree && rightTree
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

// 中序遍历
func inorder(_ root: TreeNode?, _ result: inout [Int]) {
    guard let _ = root else {
        return
    }
    
    inorder(root?.left, &result)
    result.append(root!.val)
    inorder(root?.right, &result)
}

let testTree = TreeNode.createTree([2, 1, nil, nil, 3])

isValidBST(testTree)

//: [Next](@next)
