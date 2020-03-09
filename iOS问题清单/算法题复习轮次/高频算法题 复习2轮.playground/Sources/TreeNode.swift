import Foundation

public class TreeNode {
    public var value: String
    public var left: TreeNode?
    public var right: TreeNode?
    
    public init(_ val: String) {
        value = val
    }
}

public func createTreeNode(list: [String]) -> TreeNode? {
    guard list.count > 0 else {
        return nil
    }
    
    let rootNode = TreeNode(list.first!)
    
    var queue = [TreeNode]()
    queue.append(rootNode)
    
    while !queue.isEmpty {
        
    }
    
    return rootNode
}
