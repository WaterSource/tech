import UIKit

// 0. 二叉树相关定义
// 满二叉树: 深度为k，节点数为(2^k)-1
// 完全二叉树: 只有最后一层右边缺少连续若干个点
// 深度的计算方法: [log2n]+1 ([]表示向下取整)
// 平衡二叉树: 是二叉排序树，左右子树的高度差不超过1，且左右子树都是平衡二叉树
// 二叉排序树: 左<根<右
// 红黑树: 根节点为黑，从任一节点到其每个叶子的所有路径都包含相同数目的黑色节点

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
        let treeNode = TreeNode(val)
        treeNode.left = createTreeHelper(list, &index)
        treeNode.right = createTreeHelper(list, &index)
        return treeNode
    } else {
        return nil
    }
}

// 2. 二叉树遍历

// 前序 根 - 左 - 右

@discardableResult
func perorder(_ node: TreeNode?, _ result: inout [String]) -> [String] {
    
    if let node = node {
        result.append(node.val)
        perorder(node.left, &result)
        perorder(node.right, &result)
    }
    
    return result
}

// 中序 左 - 根 - 右

@discardableResult
func inorder(_ node: TreeNode?, _ result: inout [String]) -> [String] {
    if let node = node {
        inorder(node.left, &result)
        result.append(node.val)
        inorder(node.right, &result)
    }
    return result
}

// 后序 左 - 右 - 根

@discardableResult
func postorder(_ node: TreeNode?, _ result: inout [String]) -> [String] {
    if let node = node {
        postorder(node.left, &result)
        postorder(node.right, &result)
        result.append(node.val)
    }
    return result
}

// 层级

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

// 3. 二叉树深度

func maxDepth(_ node: TreeNode?) -> Int {
    guard let node = node else {
        return 0
    }
    
    let left = maxDepth(node.left)
    let right = maxDepth(node.right)
    
    return max(left, right) + 1
}

// 4. 二叉树还原 一定有中序

func buildTreeByPreMid(_ pre: [String], _ preBegin: Int, _ preEnd: Int, _ mid: [String], _ midBegin: Int, _ midEnd: Int) -> TreeNode {
    
    // 递归 通过前序遍历的特点 拆分中序遍历为子树
    
    let node = TreeNode(pre[preBegin])
    
    // 当次循环中 根节点位置
    var midRootLoc = 0
    for i in midBegin...midEnd {
        if mid[i] == pre[preBegin] {
            midRootLoc = i
            break
        }
    }
    
    // 根节点大于起始位
    if midRootLoc > midBegin {
        // 前序的下一位作为根节点
        // preBegin + (midRootLoc - midBegin) 前半段，下一轮的子树
        // 中序范围缩减为前半段 midBegin ~ midRootLoc-1
        
        let leftChild = buildTreeByPreMid(pre, preBegin + 1, preBegin + (midRootLoc - midBegin), mid, midBegin, midRootLoc - 1)
        node.left = leftChild
    }
    
    // 根节点小于结束位
    if midEnd > midRootLoc {
        // 前序
        // 后序调整为 midRootLoc+1 ~ midEnd
        let rightChild = buildTreeByPreMid(pre, preEnd - (midEnd - midRootLoc) + 1, preEnd, mid, midRootLoc + 1, midEnd)
        node.right = rightChild
    }
    
    return node
}

// 5. 一个1..n的数组，有多少个不同的二叉树

// 在前序序列一定的情况下，所能得到的中序序列的个数

// f(n) = C(2n,n) - C(2n, n-1) = C(2n, n) / (1+n)

// C(n,m)组合数 从n个数中取出m个的取法集合
// C(n,m) = C(n-1,m-1) + C(n-1,m)

func numberOfTree(_ listCount: Int) -> Int {
    guard listCount > 1 else {
        return 1
    }
    
    var tmpDic = [Int : Int]()
    tmpDic[0] = 1
    tmpDic[1] = 1
    
    for i in 2...listCount {
        var tmp = 0
        for j in 0..<i {
            tmp += tmpDic[j]! * tmpDic[i-j-1]!
        }
        tmpDic[i] = tmp
    }
    
    return tmpDic[listCount]!
}

numberOfTree(4)

// test

let rootList = ["1", "2", "4", "8", nil, nil, "9", nil, nil, "5", "10", nil, nil, "11", nil, nil, "3", "6", "12", nil, nil, "13", nil, nil, "7", "14", nil, nil, "15"]

let node = createTree(rootList)

var resultA = [String]()
perorder(node, &resultA)
print(resultA)

var resultB = [String]()
inorder(node, &resultB)
print(resultB)

let resultC = levelOrder(node)
print(resultC)

let rebuildNode = buildTreeByPreMid(resultA, 0, resultA.count-1, resultB, 0, resultB.count-1)
print(levelOrder(rebuildNode))

