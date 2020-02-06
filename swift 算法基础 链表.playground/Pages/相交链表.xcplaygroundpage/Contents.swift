//: [Previous](@previous)

import Foundation

func getIntersectionNode(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
    guard headA != nil, headB != nil else {
        return nil
    }
    
    var tmpA: ListNode? = headA
    var tmpB: ListNode? = headB
    
    while tmpA !== tmpB {
        tmpA = (tmpA == nil ? headB : tmpA?.next)
        tmpB = (tmpB == nil ? headA : tmpB?.next)
    }
    
    return tmpA
}


let l0 = ListNodeList(1)
l0.insert(2)
l0.insert(3)

let l1 = ListNodeList(9)
l1.insert(8)
l1.insert(1)
l1.head?.next = l0.root

let l2 = ListNodeList(6)
l2.insert(7)
l2.insert(1)
l2.head?.next = l0.root

let res = getIntersectionNode(l1.root, l2.root)
res?.printList()

//: [Next](@next)
