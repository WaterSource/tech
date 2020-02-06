//: [Previous](@previous)

import Foundation

// 删除链表节点
// 注意前置节点和后续节点的连接

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
