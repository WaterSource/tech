//: [Previous](@previous)

import Foundation

// 对称二叉树，是否是镜像对称的


// 解法一
// 依次下探左右子树
func isSymmetric(_ root: TreeNode?) -> Bool {
    guard root != nil else {
        return true
    }
    
    return subSymmetric(root?.left, root?.right)
}

func subSymmetric(_ left: TreeNode?, _ right: TreeNode?) -> Bool {
    if left == nil && right == nil {
        return true
    }
    
    if left == nil || right == nil {
        return false
    }
    
    if left!.val != right!.val {
        return false
    } else {
        // 左子树的左节点，右子树的右节点
        let res1 = subSymmetric(left?.left, right?.right)
        // 左子树的右节点，右子树的左节点
        let res2 = subSymmetric(left?.right, right?.left)
        
        return  res1 && res2
    }
}

////

func isSymmetricB(_ root: TreeNode?) -> Bool {
    guard root != nil else {
        return true
    }
    
    var queueA = [TreeNode?]()
    var queueB = [TreeNode?]()
    
    queueA.append(root?.left)
    queueB.append(root?.right)
    
    while !queueA.isEmpty && !queueB.isEmpty {
        let node1 = queueA.removeFirst()
        let node2 = queueB.removeFirst()
        
        if node1 == nil, node2 == nil {
            continue
        }
        
        if node1 == nil || node2 == nil {
            return false
        }
        
        if node1!.val != node2!.val {
            return false
        }
        
        queueA.append(node1?.left)
        queueA.append(node1?.right)
        queueB.append(node2?.right)
        queueB.append(node2?.left)
    }
    
    return true
}

let testTree = TreeNode.createTree([1, 2, 3, nil, nil, 4, nil, nil, 2, 4, nil, nil, 3])

isSymmetricB(testTree)

//func levelorder(_ root: TreeNode?) -> [[Int]] {
//    guard let _ = root else {
//        return []
//    }
//
//    var result = [[Int]]()
//    var queue = [TreeNode]()
//
//    queue.append(root!)
//
//    while !queue.isEmpty {
//        let size = queue.count
//        var list = [Int]()
//
//        for _ in 0..<size {
//            let node: TreeNode = queue.removeFirst()
//            list.append(node.val!)
//
//            if node.left != nil {
//                queue.append(node.left!)
//            }
//
//            if node.right != nil {
//                queue.append(node.right!)
//            }
//        }
//
//        result.append(list)
//    }
//
//    return result
//}
//
//levelorder(testTree)

//: [Next](@next)
