//: [Previous](@previous)

import Foundation

// 删除链表的倒数第N个节点
// 使用两个指针，A指针先走N步，然后AB同时步进直到末尾

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
