//: [Previous](@previous)

import Foundation

// 两个链表，倒叙表示两个数

// 仿照人脑执行的相加操作，注意进位问题

func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    
    let root = ListNode(0)
    var head: ListNode? = root
    
    var tmpL1: ListNode? = l1
    var tmpL2: ListNode? = l2
    
    var flag = 0
    
    while flag > 0 || tmpL1 != nil || tmpL2 != nil {
        var res = 0
        
        if tmpL1 != nil {
            res += tmpL1!.val
            tmpL1 = tmpL1?.next
        }
        
        if tmpL2 != nil {
            res += tmpL2!.val
            tmpL2 = tmpL2?.next
        }
        
        if flag > 0 {
            res += flag
            flag = 0
        }
        
        flag = res / 10
        head?.next = ListNode(res%10)
        head = head?.next
    }
    
    return root.next
}

let l1 = ListNodeList(5)
//l1.insert(5)
//l1.insert(1)

let l2 = ListNodeList(5)
//l2.insert(5)

let l3 = addTwoNumbers(l1.root, l2.root)
l3?.printList()

//: [Next](@next)
