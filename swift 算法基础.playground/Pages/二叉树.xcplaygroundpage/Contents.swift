//: [Previous](@previous)

import Foundation

public class TreeNode {
    public var val: String
    public var left: TreeNode? = nil
    public var right: TreeNode? = nil
    public init(_ val: String) {
        self.val = val
    }
}

// 前序创建二叉树

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
let testTree: TreeNode? = createTree(["a", "b", "d", "", "", "e", "", "", "c",  "", "f", "", ""], &startIndex)

// 计算深度

func maxDepth(root: TreeNode?) -> Int {
    guard let root = root else {
        return 0
    }

    let left = maxDepth(root: root.left)
    let right = maxDepth(root: root.right)
    
    return max(left, right) + 1
}

print("二叉树深度:", maxDepth(root: testTree))


// 二叉查找树

//func isVaildBST(root: TreeNode?) -> Bool {
//    return helper(root, nil, nil)
//}
//
//private func helper(_ node: TreeNode?, _ min: Int?, _ max: Int?) -> Bool {
//    guard let node = node else {
//        return true
//    }
//    // 右节点大于根节点
//    if let max = max, node.val >= max {
//        return false
//    }
//    // 左节点小于根节点
//    if let min = min, node.val <= min {
//        return false
//    }
//
//    return helper(node.left, min, node.val) && helper(node.right, node.val, max)
//}

// 二叉树前序遍历

func preorderTraversalA(root: TreeNode?) -> [String] {
    var res = [String]()
    var stack = [TreeNode]()
    var node = root

    while !stack.isEmpty || node != nil {
        if node != nil {
            res.append(node!.val)
            stack.append(node!)
            node = node!.left
        } else {
            node = stack.removeLast().right
        }
    }

    return res
}

//print("二叉树前序遍历", preorderTraversalA(root: testTree))

func preorderTraversalB(root: TreeNode?, res: inout [String]) -> [String] {
    guard let root = root else {
        return res
    }
    res.append(root.val)
    
    preorderTraversalB(root: root.left, res: &res)
    preorderTraversalB(root: root.right, res: &res)
    return res
}

//var tmpPreOrderResultB = [String]()
//print("二叉树前序遍历", preorderTraversalB(root: testTree, res: &tmpPreOrderResultB))

// 二叉树中序遍历

func inorderTraversalA(root: TreeNode?) -> [String] {
    var res = [String]()
    var stack = [TreeNode]()
    var node = root
    
    while !stack.isEmpty || node != nil {
        if node != nil {
            stack.append(node!)
            node = node!.left
        } else {
            let tmp = stack.removeLast()
            res.append(tmp.val)
            node = tmp.right
        }
    }
    
    return res
}

//print("二叉树中序遍历", inorderTraversalA(root: testTree))

func inorderTraversalB(root: TreeNode?, res: inout [String]) -> [String] {
    guard let root = root else {
        return res
    }
    
    inorderTraversalB(root: root.left, res: &res)
    res.append(root.val)
    inorderTraversalB(root: root.right, res: &res)
    return res
}

//var tmpInorderResultB = [String]()
//print("二叉树中序遍历", inorderTraversalB(root: testTree, res: &tmpInorderResultB))

// 二叉树后序遍历

func postorderTraversalA(root: TreeNode?) -> [String] {
    guard let root = root else {
        return []
    }
    
    var res = [String]()
    var stack = [TreeNode]()
    var node: TreeNode? = root
    var tmpNode: TreeNode? = nil
    
    stack.append(root)
    
    while !stack.isEmpty {
        node = stack.last
        
        if tmpNode == nil ||
            tmpNode?.left === node ||
            tmpNode?.right === node {
            // tmp是node的父节点
            
            if node?.left != nil {
                stack.append(node!.left!)
            } else if node?.right != nil {
                stack.append(node!.right!)
            }
        } else if node?.left === tmpNode {
            // node是tmp的父节点
            
            if node?.right != nil {
                stack.append(node!.right!)
            }
        } else {
            res.append(stack.removeLast().val)
        }
        
        tmpNode = node
    }
    
    return res
}

//print("二叉树后序遍历", postorderTraversalA(root: testTree))

func postorderTraversalB(root: TreeNode?) -> [String] {
    var node: TreeNode? = root
    var stack = [TreeNode]()
    var res = [String]()
    
    while node != nil || !stack.isEmpty {
        
        // 先向右下探
        while node != nil {
            res.append(node!.val)
            stack.append(node!)
            node = node?.right
        }
        
        // 到底之后回到上一个节点的左子树
        if !stack.isEmpty {
            node = stack.removeLast()
            node = node?.left
        }
    }
    
    // 逆序
    return res.reversed()
}

//print("二叉树后序遍历", postorderTraversalB(root: testTree))

func postorderTraversalC(root: TreeNode?, res: inout [String]) -> [String] {
    guard let root = root else {
        return res
    }
    
    postorderTraversalC(root: root.left, res: &res)
    postorderTraversalC(root: root.right, res: &res)
    res.append(root.val)
    return res
}

//var tmpPostorderResultC = [String]()
//print("二叉树后序遍历", postorderTraversalC(root: testTree, res: &tmpPostorderResultC))

// 层次遍历

func levelOrderTraversalA(root: TreeNode?) -> [String] {
    guard let root = root else {
        return []
    }
    
    var node: TreeNode? = root
    var queue = [TreeNode]()
    var res = [String]()
    
    queue.append(node!)
    
    while !queue.isEmpty {
        node = queue.removeFirst()
        res.append(node!.val)
        
        if let left = node?.left {
            queue.append(left)
        }
        
        if let right = node?.right {
            queue.append(right)
        }
    }
    
    return res
}

//print("二叉树层次遍历", levelOrderTraversalA(root: testTree))

// 二叉树线索化

public class BinaryTreeNode {
    public var val: String
    public var left: BinaryTreeNode?
    public var right: BinaryTreeNode?
    
    // true=指向左子树 false=指向前驱
    public var leftTag: Bool = true
    // true=指向右子树 false=指向后继
    public var rightTag: Bool = true
    
    public init(_ val: String) {
        self.val = val
    }
}

class BinaryTree {
    private var root: BinaryTreeNode?
    fileprivate var items: Array<String>
    
    init(_ items: Array<String>) {
        self.items = items
        root = createTree()
        
        headNode = BinaryTreeNode("")
        headNode?.left = root
        headNode?.leftTag = true
        
        preNode = headNode
    }
    
    // 前序遍历创建
    fileprivate var index = -1
    
    fileprivate func createTree() -> BinaryTreeNode? {
        self.index += 1
        if index < self.items.count && index >= 0 {
            let item = self.items[index]
            if item == "" {
                return nil
            } else {
                let root = BinaryTreeNode(item)
                root.left = createTree()
                root.right = createTree()
                return root
            }
        }
        return nil
    }
    
    // 前序遍历
    fileprivate func preorderTraversal(_ root: BinaryTreeNode?) {
        guard let root = root else {
            return
        }
        print(root.val, separator: "", terminator: " ")
        if root.leftTag {
            preorderTraversal(root.left)
        }
        if root.rightTag {
            preorderTraversal(root.right)
        }
    }
    
    func preOrder() {
        print("先序遍历")
        preorderTraversal(root)
        print("\n")
    }
    
    fileprivate var preNode: BinaryTreeNode?
    fileprivate var headNode: BinaryTreeNode?
    
    // 中序遍历，线索化，将结果生成链表
    private func inorderTraversal(_ root: BinaryTreeNode?) {
        if root != nil {
            inorderTraversal(root?.left)
            
            // 如果节点的左节点为nil，那么将该节点指向中序遍历的前驱
            if root?.left == nil {
                root?.leftTag = false
                root?.left = preNode
            }
            
            // 如果节点的中序遍历的前驱的右节点为nil，那么将该前驱节点的右节点指向该点关联
            if preNode?.right == nil {
                preNode?.rightTag = false
                preNode?.right = root
            }
            preNode = root
            inorderTraversal(root?.right)
        }
    }
    
    func inOrder() {
        inorderTraversal(root)
    }
    
    func displayBinaryTree() {
        print("遍历线索化二叉树")
        var cursor = self.headNode?.right
        while cursor != nil {
            print((cursor?.val)!, separator: "", terminator: " -> ")
            cursor = cursor?.right
        }
        
        print("end")
    }
}

//let items: Array<String> = ["A", "B", "D", "", "", "E", "", "", "C", "", "F", "", ""]
//let binaryTree = BinaryTree(items)
//binaryTree.inOrder()
//binaryTree.displayBinaryTree()
//binaryTree.preOrder()

// 二叉树还原

// 二叉树前序+中序还原
func buildTreeByPreMid(_ pre: [String], _ preBegin: Int, _ preEnd: Int, _ mid: [String], _ midBegin: Int, _ midEnd: Int) -> TreeNode {
    
    print("preBegin=", preBegin, "preEnd=", preEnd)
    print("midBegin=", midBegin, "midEnd=", midEnd)
    
    let node = TreeNode(pre[preBegin] + "")
    print("当前节点", node.val)
    
    // 找到根节点
    var midRootLoc = 0
    for i in midBegin...midEnd {
        if mid[i] == pre[preBegin] {
            midRootLoc = i
            break
        }
    }
    
    print("对应中序遍历节点位置是\(midRootLoc)")
    
    // 递归得到左子树
    // 结束位置大于起始位置
    if preBegin + (midRootLoc - midBegin) >= preBegin + 1 &&
        (midRootLoc - 1) >= midBegin {
        
        let leftChild = buildTreeByPreMid(pre,
                                          // 前序下一位 - 下一个左根节点
                                          preBegin + 1,
                                          // 该节点下的所有子节点
                                          preBegin + (midRootLoc - midBegin),
                                          
                                          mid,
                                          
                                          midBegin,
                                          
                                          midRootLoc - 1)
        node.left = leftChild
    }
    
    // 递归得到右子树
    if preEnd >= (preEnd - (midEnd - midRootLoc) + 1) &&
        (midEnd >= midRootLoc + 1) {
        
        let rightChild = buildTreeByPreMid(pre,
                                           // 下一个右根节点
                                           preEnd - (midEnd - midRootLoc) + 1,
                                           
                                           preEnd,
                                           
                                           mid,
                                           
                                           midRootLoc + 1,
                                           
                                           midEnd)
        node.right = rightChild
    }
    
    return node
}

func rebuildTreeByMidEnd(_ mid: [String], _ midBegin: Int, _ midEnd: Int, _ post: [String], _ postBegin: Int, _ postEnd: Int) -> TreeNode {
    
    let root = TreeNode(post[postEnd] + "")
    
    var midRootLoc = 0
    for i in (midBegin...midEnd).reversed() {
        if post[postEnd] == mid[i] {
            midRootLoc = i
            break
        }
    }
    
    // 还原左子树
    let leftMidBegin = midBegin
    let leftMidEnd = midRootLoc - 1
    let leftPostBegin = postBegin
    let leftPostEnd = postBegin + (midRootLoc - midBegin) - 1
    
    if leftMidEnd >= leftMidBegin && leftPostEnd >= leftPostBegin {
        let leftNode = rebuildTreeByMidEnd(mid, leftMidBegin, leftMidEnd, post, leftPostBegin, leftPostEnd)
        root.left = leftNode
    }
    
    // 还原右子树
    let rightMidBegin = midRootLoc + 1
    let rightMidEnd = midEnd
    let rightPostBegin = postEnd - (midEnd - midRootLoc)
    let rightPostEnd = postEnd - 1
    
    if rightMidEnd >= rightMidBegin && rightPostEnd >= rightPostBegin {
        let rightNode = rebuildTreeByMidEnd(mid, rightMidBegin, rightMidEnd, post, rightPostBegin, rightPostEnd)
        root.right = rightNode
    }
    
    return root
}

func rebuildTreeByMidLevel(_ mid: [String], _ midBegin: Int, _ midEnd: Int, _ level: [String], _ levelBegin: Int, _ levelEnd: Int) -> TreeNode {
    
    let root = TreeNode(level[0] + "")
    
    var midLoc = 0
    for i in midBegin...midEnd {
        if mid[i] == level[0] {
            midLoc = i
            break
        }
    }
    
    if level.count >= 2 {
        if isLeft(mid, level[0], level[1]) {
            let nextLevel1 = getLevelStr(mid, midBegin, midLoc - 1, level)
            print("左子树 ", nextLevel1)
            let leftNode = rebuildTreeByMidLevel(mid, midBegin, midLoc - 1, nextLevel1, levelBegin, levelEnd)
            root.left = leftNode
            
            if level.count >= 3, !isLeft(mid, level[0], level[2]) {
                let nextLevel2 = getLevelStr(mid, midLoc + 1, midEnd, level)
                
                let rightNode = rebuildTreeByMidLevel(mid, midLoc + 1, midEnd, nextLevel2, levelBegin, levelEnd)
                root.right = rightNode
            }
        } else {
            let nextLevel3 = getLevelStr(mid, midLoc + 1, midEnd, level)
            
            let rightNode = rebuildTreeByMidLevel(mid, midLoc + 1, midEnd, nextLevel3, levelBegin, levelEnd)
            root.right = rightNode
        }
    }
    
    return root
}

func isLeft(_ str: [String], _ target: String, _ c: String) -> Bool {
    var findC = false
    for tmp in str {
        if tmp == c {
            findC = true
        } else if tmp == target {
            return findC
        }
    }
    return false
}

func getLevelStr(_ mid: [String], _ midBegin: Int, _ midEnd: Int, _ level: [String]) -> [String] {
    
    var result = [String]()
    var curLoc = 0
    for i in 0..<level.count {
        if contains(mid, level[i], midBegin, midEnd) {
            result[curLoc] = level[i]
            curLoc += 1
        }
    }
    return result
}

func contains(_ str: [String], _ target: String, _ begin: Int, _ end: Int) -> Bool {
    for i in begin...end {
        if str[i] == target {
            return true
        }
    }
    return false
}

let pre = ["A", "B", "D", "G", "H", "C", "E", "I", "F"]
let mid = ["G", "D", "H", "B", "A", "E", "I", "C", "F"]
//let post = ["A", "B", "D", "G", "H", "C", "E", "I", "F"]

let rebuildNode = buildTreeByPreMid(pre, 0, pre.count - 1, mid, 0, mid.count - 1)
let nodeE = rebuildNode.right?.left!
print("\(nodeE?.val) left=\(nodeE?.left?.val) right=\(nodeE?.right?.val)")
