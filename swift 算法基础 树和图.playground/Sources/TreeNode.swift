import Foundation

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    
    public init(_ val: Int) {
        self.val = val
    }
    
    public class func createTree(_ data: [Int?]) -> TreeNode? {
        var startIndex = -1
        return createTreeHelper(data, &startIndex)
    }
    
    class func createTreeHelper(_ data: [Int?], _ index: inout Int) -> TreeNode? {
        index += 1
        
        guard index < data.count else {
            return nil
        }
        
        if let item = data[index] {
            let node = TreeNode(item)
            node.left = createTreeHelper(data, &index)
            node.right = createTreeHelper(data, &index)
            return node
        }
        
        return nil
    }
}

public extension TreeNode {
    func preorder() -> [Int] {
        var result = [Int]()
        preorderHelper(self, &result)
        return result
    }
    
    func preorderHelper(_ node: TreeNode?, _ list: inout [Int]) {
        guard let node = node else {
            return
        }
        
        list.append(node.val)
        preorderHelper(node.left, &list)
        preorderHelper(node.right, &list)
    }
    
    func inorder() -> [Int] {
        var result = [Int]()
        inorderHelper(self, &result)
        return result
    }
    
    func inorderHelper(_ node: TreeNode?, _ list: inout [Int]) {
        guard let node = node else {
            return
        }
        
        inorderHelper(node.left, &list)
        list.append(node.val)
        inorderHelper(node.right, &list)
    }

    func lastorder() -> [Int] {
        var result = [Int]()
        lastorderHelper(self, &result)
        return result
    }
    
    func lastorderHelper(_ node: TreeNode?, _ list: inout [Int]) {
        guard let node = node else {
            return
        }
        
        lastorderHelper(node.left, &list)
        lastorderHelper(node.right, &list)
        list.append(node.val)
    }

    func levelorder() -> [Int] {
        var result = [Int]()
        
        var stack = [TreeNode]()
        stack.append(self)
        
        while !stack.isEmpty {
            let node = stack.removeFirst()
            
            if node.left != nil {
                stack.append(node.left!)
            }
            
            if node.right != nil {
                stack.append(node.right!)
            }
            
            result.append(node.val)
        }
        
        return result
    }
}
