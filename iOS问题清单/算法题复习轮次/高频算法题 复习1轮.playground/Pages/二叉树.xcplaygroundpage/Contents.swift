//: [Previous](@previous)

import Foundation

class TreeNode {
    var val: String
    var left: TreeNode?
    var right: TreeNode?
    
    init(_ val: String) {
        self.val = val
    }
}

// 1. 二叉树生成
func createTree(_ list: [String?]) -> TreeNode? {
    guard list.count > 0 else {
        return nil
    }
    
    var index = -1
    return createTreeHelper(list, &index)
}

func createTreeHelper(_ list: [String?], _ index: inout Int) -> TreeNode? {
    index += 1
    
    guard index < list.count else {
        return nil
    }
    
    if let val = list[index] {
        // 前序生成
        let treeNode = TreeNode(val)
        treeNode.left = createTreeHelper(list, &index)
        treeNode.right = createTreeHelper(list, &index)
        return treeNode
    } else {
        return nil
    }
}

// 前序遍历
func perorder(_ node: TreeNode?, _ result: inout [String]) -> [String] {
    if let node = node {
        result.append(node.val)
        perorder(node.left, &result)
        perorder(node.right, &result)
    }
    
    return result
}

// 层级遍历
func levelOrder(_ node: TreeNode?) -> [String] {
    guard let node = node else {
        return []
    }
    
    var stack = [TreeNode]()
    var result = [String]()
    
    stack.append(node)
    
    while !stack.isEmpty {
        let tmp = stack.removeFirst()
        result.append(tmp.val)
        
        if let left = tmp.left {
            stack.append(left)
        }
        
        if let right = tmp.right {
            stack.append(right)
        }
    }
    
    return result
}

func createTreeByLevel(_ arr: [String?]) -> TreeNode? {
    var list = arr
    guard let rootVal = list.removeFirst() else {
        return nil
    }
    
    let root = TreeNode(rootVal)
    var stack = [root]
    
    while !list.isEmpty, !stack.isEmpty {
        let tmp = stack.removeFirst()
        
        if let left = list.removeFirst() {
            let leftNode = TreeNode(left)
            tmp.left = leftNode
            stack.append(leftNode)
        }
        
        if let right = list.removeFirst() {
            let rightNode = TreeNode(right)
            tmp.right = rightNode
            stack.append(rightNode)
        }
    }
    return root
}

//: [Next](@next)
