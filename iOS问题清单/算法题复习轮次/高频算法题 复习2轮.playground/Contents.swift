import UIKit

let list = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"]
let tmp = TreeNode.createTreeNode(list: list)

func maxDepth(tree: TreeNode?) -> Int {
    guard let tree = tree else {
        return 0
    }
    
    return max(maxDepth(tree: tree.left), maxDepth(tree: tree.right)) + 1
}

//maxDepth(tree: tmp)

func minDepth(tree: TreeNode?) -> Int {
    guard let tree = tree else {
        return 0
    }
    
    let leftDepth = minDepth(tree: tree.left)
    let rightDepth = minDepth(tree: tree.right)
    
    return (leftDepth == 0 || rightDepth == 0) ? leftDepth + rightDepth + 1 : min(leftDepth, rightDepth) + 1
}

//minDepth(tree: tmp)

func isMirror(tree: TreeNode) -> Bool {
    
    func mirrorHelper(node1: TreeNode?, node2: TreeNode?) -> Bool {
        
        if node1 == nil, node2 == nil {
            return true
        }
        
        if node1 == nil || node2 == nil {
            return false
        }
        
        guard node1?.value == node2?.value else {
            return false
        }
        
        return mirrorHelper(node1: node1?.left, node2: node2?.right) && mirrorHelper(node1: node1?.right, node2: node2?.left)
    }
    
    return mirrorHelper(node1: tree, node2: tree)
}

func perorder(_ node: TreeNode?, _ result: inout [String]) -> [String] {
    
    guard let node = node else {
        return result
    }
    
    result.append(node.value)
    perorder(node.left, &result)
    perorder(node.right, &result)
    
    return result
}

func levelOrder(_ node: TreeNode) -> [String] {
    var queue = [TreeNode]()
    queue.append(node)
    
    var result = [String]()
    
    while !queue.isEmpty {
        let tmpNode = queue.removeFirst()
        result.append(tmpNode.value)
        
        if tmpNode.left != nil {
            queue.append(tmpNode.left!)
        }
        
        if tmpNode.right != nil {
            queue.append(tmpNode.right!)
        }
    }
    
    return result
}

//levelOrder(tmp!)

func zLevelOrder(_ node: TreeNode) -> [[String]] {
    var queue = [TreeNode]()
    queue.append(node)
    
    var result = [[String]]()
    var depth = 0
    
    while !queue.isEmpty {
        let size = queue.count
        var tmpList = [String]()
        
        for _ in 0..<size {
            let tmpNode = queue.removeFirst()
            tmpList.append(tmpNode.value)
            
            if tmpNode.left != nil {
                queue.append(tmpNode.left!)
            }
            
            if tmpNode.right != nil {
                queue.append(tmpNode.right!)
            }
        }
        
        if depth%2 == 1 {
            result.append(tmpList.reversed())
        } else {
            result.append(tmpList)
        }
        
        depth += 1
    }
    
    return result
}

//print(zLevelOrder(tmp!))

func rebuildTree(_ pre: [String], _ mid: [String]) -> TreeNode {
    
    func rebuildTreeHelper(_ pre: [String], _ preBeginIndex: Int, _ preEndIndex: Int, _ mid: [String], _ midBeginIndex: Int, _ midEndIndex: Int) -> TreeNode {
        
        let rootNode = TreeNode(pre[preBeginIndex])
        
        var rootIndexInMid = 0
        for i in midBeginIndex...midEndIndex {
            if mid[i] == pre[preBeginIndex] {
                rootIndexInMid = i
                break
            }
        }
        
        if rootIndexInMid > midBeginIndex {
            let leftChild = rebuildTreeHelper(pre, preBeginIndex + 1, preBeginIndex + (rootIndexInMid - midBeginIndex), mid, midBeginIndex, rootIndexInMid - 1)
            rootNode.left = leftChild
        }
        
        if rootIndexInMid < midEndIndex {
            let rightChild = rebuildTreeHelper(pre, preEndIndex - (midEndIndex - rootIndexInMid) + 1, preEndIndex, mid, rootIndexInMid + 1, midEndIndex)
            rootNode.right = rightChild
        }
        
        return rootNode
    }
    
    return rebuildTreeHelper(pre, 0, pre.count-1, mid, 0, mid.count-1)
}

// 公共祖先
func lowestCommonAncestor(_ rootNode: TreeNode?, _ node1: TreeNode, _ node2: TreeNode) -> TreeNode? {
    
    guard let rootNode = rootNode else {
        return nil
    }
    
    if rootNode.value == node1.value || rootNode.value == node2.value {
        return rootNode
    }
    
    let leftChild = lowestCommonAncestor(rootNode.left, node1, node2)
    let rightChild = lowestCommonAncestor(rootNode.right, node1, node2)
    
    if leftChild != nil && rightChild != nil {
        return rootNode
    }
    
    return leftChild != nil ? leftChild : rightChild
}

// 根据有序队列，建立二叉搜索树
func buildBST(_ info: [String]) -> TreeNode? {
    
    func buildBSTHelper(_ info: [String], _ leftIndex: Int, _ rightIndex: Int) -> TreeNode? {
        guard leftIndex < rightIndex else {
            return nil
        }
        
        let mid = (rightIndex - leftIndex) / 2
        let node = TreeNode(info[mid])
        
        node.left = buildBSTHelper(info, leftIndex, mid - 1)
        node.right = buildBSTHelper(info, mid + 1, rightIndex)
        
        return node
    }
    
    return buildBSTHelper(info, 0, info.count - 1)
}

// 根据1...n，能生成多少种形态的二叉树
// f(n) = C(2n, n) / (1+n)
//      = h(0)*h(n-1)+h(1)*h(n-2)+...+h(n-1)*h(0)
func numberOfTree(_ n: Int) -> Int {
    guard n > 1 else {
        return 1
    }
    
    var result = [Int: Int]()
    result[0] = 1
    result[1] = 1
    
    for i in 2...n {
        var tmp = 0
        for j in 0..<i {
            tmp += result[j]! * result[i-j-1]!
        }
        result[i] = tmp
    }
    return result[n]!
}
//numberOfTree(2)

// 1...n生成二叉搜索树的个数
func numberOfBST(_ n: Int) -> Int {
    
    func numberOfBSTHelper(_ leftIndex: Int, _ rightIndex: Int) -> [TreeNode] {
        
        guard leftIndex <= rightIndex else {
            return []
        }
        
        if leftIndex == rightIndex {
            return [TreeNode("\(leftIndex)")]
        }
        
        var result = [TreeNode]()
        
        for i in leftIndex...rightIndex {
            // i为根节点时
            
            // 左右子树可能的所有情况
            let leftChild = numberOfBSTHelper(leftIndex, i - 1)
            let rightChild = numberOfBSTHelper(i + 1, rightIndex)
            
            if leftChild.isEmpty, rightChild.isEmpty {
                continue
                
            } else if leftChild.isEmpty {
                // 右子树枚举
                for k in 0..<rightChild.count {
                    let tmp = TreeNode("\(i)")
                    tmp.left = nil
                    tmp.right = rightChild[k]
                    result.append(tmp)
                }
            } else if rightChild.isEmpty {
                // 左子树枚举
                for j in 0..<leftChild.count {
                    let tmp = TreeNode("\(i)")
                    tmp.left = leftChild[j]
                    tmp.right = nil
                    result.append(tmp)
                }
            } else {
                // 左子树枚举
                for j in 0..<leftChild.count {
                    // 右子树枚举
                    for k in 0..<rightChild.count {
                        
                        let tmp = TreeNode("\(i)")
                        tmp.left = leftChild[j]
                        tmp.right = rightChild[k]
                        result.append(tmp)
                    }
                }
            }
        }
        
        return result
    }
    
    let res = numberOfBSTHelper(1, n)
    print(res)
    
    return res.count
}

numberOfBST(3)
