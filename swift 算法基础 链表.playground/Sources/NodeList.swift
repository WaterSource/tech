import Foundation

public class ListNode {
    public var val: Int
    public var next: ListNode?
    
    public init(_ x: Int) {
        val = x
        next = nil
    }
    
    public func printList() {
        var tmp: ListNode? = self
        while tmp != nil {
            print("node", tmp!.val)
            tmp = tmp?.next
        }
    }
}

public class ListNodeList {
    public var root: ListNode?
    public var head: ListNode?
    
    public init(_ x: Int) {
        let node = ListNode(x)
        self.root = node
        self.head = node
    }
    
    public func insert(_ x: Int) {
        let node = ListNode(x)
        head?.next = node
        head = node
    }
    
    public func printAll() {
        var node: ListNode? = root
        while node != nil {
            print("node", node?.val)
            node = node?.next
        }
    }
}
