import Foundation

public class TreeNode: CustomStringConvertible {
    public var value: String
    public var left: TreeNode?
    public var right: TreeNode?
    
    public init(_ val: String) {
        value = val
    }
    
    public var description: String {
        var res: String = "["
        
        var queue = [TreeNode]()
        queue.append(self)
        
        var level = 0
        
        while !queue.isEmpty {
            let size = queue.count
            
            var tmpRes: String = "L\(level)"
            
            for _ in 0..<size {
                let tmp = queue.removeFirst()
                
                tmpRes += " "
                tmpRes += tmp.value
                
                if tmp.value != "NULL" {
                    if tmp.left != nil {
                        queue.append(tmp.left!)
                    } else {
                        queue.append(TreeNode("NULL"))
                    }
                    
                    if tmp.right != nil {
                        queue.append(tmp.right!)
                    } else {
                        queue.append(TreeNode("NULL"))
                    }
                }
            }
            
            level += 1
            
            res += tmpRes
            res += " "
        }
        
        res += "]"
        return res
    }
    
    public class func createTreeNode(list: [String?]) -> TreeNode? {
        guard list.count > 0,
            let firstValue = list.first! else {
            return nil
        }
        
        var tmpList = list
        tmpList.removeFirst()
        
        let rootNode = TreeNode(firstValue)
        
        var queue = [TreeNode]()
        queue.append(rootNode)
        
        while !tmpList.isEmpty, !queue.isEmpty {
            let tmp = queue.removeFirst()
            
            if let leftValue = tmpList.removeFirst() {
                let leftNode = TreeNode(leftValue)
                tmp.left = leftNode
                queue.append(leftNode)
            }
            
            if tmpList.count > 0,
                let rightValue = tmpList.removeFirst() {
                let rightNode = TreeNode(rightValue)
                tmp.right = rightNode
                queue.append(rightNode)
            }
        }
        
        return rootNode
    }
}

