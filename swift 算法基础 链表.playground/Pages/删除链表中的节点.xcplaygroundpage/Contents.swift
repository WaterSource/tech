//: [Previous](@previous)

import Foundation

class ListNode {
    var val: Int?
    var next: ListNode?
    
    init(_ x: Int) {
        val = x
        next = nil
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

func deleteNode(_ node: ListNode) {
    let next = node.next
    node.val = next?.val
    node.next = next?.next
}

let list = ListNodeList(1)
list.insert(2)
list.insert(3)
list.insert(4)
let test = list.head
list.insert(5)

deleteNode(test!)

list.printAll()

//: [Next](@next)
