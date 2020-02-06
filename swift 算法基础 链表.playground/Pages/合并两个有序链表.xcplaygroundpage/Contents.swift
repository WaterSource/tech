//: [Previous](@previous)

import Foundation

// 合并两个有序链表

func mergeTwoLists(_ list1: ListNode, _ list2: ListNode) -> ListNode {
    let root = ListNode(0)
    
    var tmp1: ListNode? = list1
    var tmp2: ListNode? = list2
    var head: ListNode? = root
    
    while tmp1 != nil, tmp2 != nil {
        if let value1 = tmp1?.val,
            let value2 = tmp2?.val {
            
            if value1 <= value2 {
                head?.next = tmp1
                tmp1 = tmp1?.next
            } else {
                head?.next = tmp2
                tmp2 = tmp2?.next
            }
            
            head = head?.next
        }
    }
    
    while tmp1 != nil {
        head?.next = tmp1
        tmp1 = tmp1?.next
        head = head?.next
    }
    
    while tmp2 != nil {
        head?.next = tmp2
        tmp2 = tmp2?.next
        head = head?.next
    }
    
    return root.next!
}

let list1 = ListNodeList(2)
//list1.insert(2)
//list1.insert(4)

let list2 = ListNodeList(1)
//list2.insert(3)
//list2.insert(4)

let re = mergeTwoLists(list1.root!, list2.root!)
re.printList()

//: [Next](@next)
