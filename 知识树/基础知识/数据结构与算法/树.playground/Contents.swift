import UIKit

class TreeNode {
    var val: String?
    var left: TreeNode?
    var right: TreeNode?
    
    init(_ val: String?) {
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
            let node = TreeNode(item)
            node.left = createTree(datasource, &index)
            node.right = createTree(datasource, &index)
            return node
        }
    }
    
    return nil
}

// 递归遍历 前中后序

func preorder(_ head: TreeNode?, _ result: inout [String]) -> [String] {
    guard head != nil else {
        return result
    }
    
    
    preorder(head?.left, &result)
    result.append(head!.val!)
    preorder(head?.right, &result)
    
    return result
}

// 非递归 前序遍历

func preorderTraversal(_ head: TreeNode?) -> [String] {
    guard head != nil else {
        return []
    }
    
    var tmp = head
    var result = [String]()
    var tmpStack = [TreeNode]()
    
    while tmp != nil || !tmpStack.isEmpty {
        if tmp != nil {
            result.append(tmp!.val!)
            tmpStack.append(tmp!)
            tmp = tmp?.left
        } else {
            tmp = tmpStack.removeLast()
            tmp = tmp?.right
        }
    }
    
    return result
}

// 非递归中序遍历

func inorderTraversal(_ head: TreeNode?) -> [String] {
    guard head != nil else {
        return []
    }
    
    var result = [String]()
    var tmp = head
    var stack = [TreeNode]()
    
    while tmp != nil || !stack.isEmpty {
        if tmp != nil {
            stack.append(tmp!)
            tmp = tmp?.left
        } else {
            tmp = stack.removeLast()
            result.append(tmp!.val!)
            tmp = tmp?.right
        }
    }
    
    return result
}

// 非递归后续遍历

func postorderTraversal(_ head: TreeNode?) -> [String] {
    guard head != nil else {
        return []
    }
    
    var result = [String]()
    var tmp = head
    var stack = [TreeNode]()
    
    var top: TreeNode? = nil
    var last: TreeNode? = nil
    
    while tmp != nil || !stack.isEmpty {
        if tmp != nil {
            stack.append(tmp!)
            tmp = tmp?.left
        } else {
            top = stack.last
            if top?.right == nil || top?.right === last {
                // 需要确定右子树已经遍历完成之后才移除
                stack.removeLast()
                result.append(top!.val!)
                last = top
            } else {
                tmp = top?.right
            }
        }
    }
    
    
    return result
}

// 层序遍历 深度优先

func leverTraversalDFSEnter(_ head: TreeNode?) -> [[String]] {
    var result = [[String]]()
    levelTraversalDFS(head, 1, &result)
    return result
}

func levelTraversalDFS(_ head: TreeNode?, _ level: Int, _ result: inout [[String]]) {
    guard head != nil else {
        return
    }
    
    if level > result.count {
        result.append([String]())
    }
    
    result[level-1].append(head!.val!)
    levelTraversalDFS(head?.left, level+1, &result)
    levelTraversalDFS(head?.right, level+1, &result)
}

// 层序遍历 广度优先

func levelOrderBFS(_ head: TreeNode?) -> [[String]] {
    var queue = [TreeNode]()
    var tmp: TreeNode?
    var result = [[String]]()
    
    if head != nil {
        return result
    }
    
    queue.append(head!)
    
    while !queue.isEmpty {
        let size = queue.count
        var levelResult = [String]()
        
        for _ in 0..<size {
            tmp = queue.removeFirst()
            levelResult.append(tmp!.val!)
            
            if tmp?.left != nil {
                queue.append(tmp!.left!)
            }
            
            if tmp?.right != nil {
                queue.append(tmp!.right!)
            }
        }
        
        result.append(levelResult)
    }
    
    return result
}

// 二叉树子树

func isSubtree(_ treeA: TreeNode?, _ treeB: TreeNode?) -> Bool {
    if treeA == nil {
        return false
    }
    
    if sameTree(treeA, treeB) {
        return true
    }
    
    return isSubtree(treeA?.left, treeB) || isSubtree(treeA?.right, treeB)
}

func sameTree(_ treeA: TreeNode?, _ treeB: TreeNode?) -> Bool {
    if treeA == nil && treeB == nil {
        return true
    }
    
    if treeA == nil || treeB == nil {
        return false
    }
    
    if treeA!.val! != treeB!.val! {
        return false
    }
    
    return sameTree(treeA?.left, treeB?.left) && sameTree(treeA?.right, treeB?.right)
}

// 翻转二叉树 交换树的左右儿子节点

func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard root != nil else {
        return nil
    }
    
    let tmp = root?.left
    root?.left = root?.right
    root?.right = tmp
    
    if root?.left != nil {
        invertTree(root?.left)
    }
    
    if root?.right != nil {
        invertTree(root?.right)
    }
    
    return root
}

// test

var startIndex = -1
let testTree = createTree(["a", "b", "d", "", "", "e", "", "", "c", "", "f", "", ""], &startIndex)

var result = [String]()
print(preorder(testTree, &result))

print(inorderTraversal(testTree))
