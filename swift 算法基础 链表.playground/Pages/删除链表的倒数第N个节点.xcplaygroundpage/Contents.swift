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

func removeNthFormEnd(_ node: ListNode, n: Int) -> ListNode {
    
    let root = ListNode(0)
    root.next = node
    
    var fast: ListNode? = root
    var slow: ListNode? = root
    var times = 0
    
    while fast?.next != nil {
        times += 1
        
        fast = fast!.next
        if times > n {
            slow = slow!.next
        }
    }
    
    print("fast=", fast?.val, "slow=", slow?.val)
    
    slow?.next = slow?.next?.next
    
    return node
}

let list = ListNodeList(1)
list.insert(2)
list.insert(3)
list.insert(4)
list.insert(5)

list.printAll()
removeNthFormEnd(list.root!, n: 2)
list.printAll()

//: [Next](@next)
