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
            print("node", tmp?.val)
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

func reverseList(_ head: ListNode) -> ListNode {
    
    let root = ListNode(0)
    root.next = head
    
    let node: ListNode? = head
    
    while node?.next != nil {
        let next = node?.next
        node?.next = next?.next
        next?.next = root.next
        root.next = next
    }
    
    return root.next!
}

let list = ListNodeList(1)
list.insert(2)
list.insert(3)
list.insert(4)
list.insert(5)

reverseList(list.root!).printList()

//: [Next](@next)
