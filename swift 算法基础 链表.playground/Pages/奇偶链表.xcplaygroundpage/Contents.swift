//: [Previous](@previous)

import Foundation

// 奇偶链表
//

func oddEvenList(_ head: ListNode?) -> ListNode? {
    guard head != nil, head?.next != nil else {
        return head
    }
    
    var odd = head
    var even = head?.next
    
    var tmp = even
    
    while even != nil, even?.next != nil {
        odd?.next = even?.next
        odd = odd?.next
        even?.next = odd?.next
        even = even?.next
    }
    
    odd?.next = tmp
    
    return head
}

let list1 = ListNodeList(1)
list1.insert(2)
list1.insert(3)
list1.insert(4)
list1.insert(5)
list1.insert(6)
list1.insert(7)
list1.insert(8)

let list = oddEvenList(list1.root)
list?.printList()

//: [Next](@next)
