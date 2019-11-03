//: [Previous](@previous)

import Foundation

class ListNode {
    var val: Int?
    var next: ListNode?
    
    init(_ x: Int) {
        val = x
        next = nil
    }
    
    func printList() {
        var tmp: ListNode? = self
        while tmp != nil {
            print("node", tmp!.val!)
            tmp = tmp?.next
        }
    }
}

class ListNodeList {
    var root: ListNode?
    var head: ListNode?
    
    init(_ x: Int) {
        let node = ListNode(x)
        self.root = node
        self.head = node
    }
    
    func insert(_ x: Int) {
        let node = ListNode(x)
        head?.next = node
        head = node
    }
    
    func printAll() {
        var node: ListNode? = root
        while node != nil {
            print("node", node?.val ?? 0)
            node = node?.next
        }
    }
}

func hasCycle(_ head: ListNode?) -> Bool {
    guard let head = head else {
        return false
    }
    
    var fast: ListNode? = head
    var slow: ListNode? = head
    
    while fast?.next != nil, fast?.next?.next != nil {
        fast = fast?.next?.next
        slow = slow?.next
        
        if let fast = fast, let slow = slow,
            fast === slow {
            return true
        }
    }
    
    return false
}

//: [Next](@next)
