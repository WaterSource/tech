//: [Previous](@previous)

import Foundation

// 反转链表
// 通过新建链表头，将后续的节点依次前移

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
