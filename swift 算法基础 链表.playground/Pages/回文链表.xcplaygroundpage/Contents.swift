//: [Previous](@previous)

import Foundation

// 判断链表是回文链表

// 通过快慢指针，找到链表中点；将后半段反转，再步进比较两个链表是否相同

func isPalindrome(head: ListNode?) -> Bool {
    guard head != nil,
        head?.next != nil else {
        return true
    }
    
    var tmp = head
    var fast: ListNode? = head
    var slow: ListNode? = head
    
    while fast?.next != nil, fast?.next?.next != nil {
        fast = fast?.next?.next
        slow = slow?.next
    }
    
    slow = reverse(head: slow?.next)
    
    while slow != nil {
        if let value1 = tmp?.val,
            let value2 = slow?.val,
            value1 != value2 {
            return false
        }
        tmp = tmp?.next
        slow = slow?.next
    }
    
    return true
}

func reverse(head: ListNode?) -> ListNode? {
    guard let _ = head?.next else {
        return head
    }
    
    let newHead = reverse(head: head?.next)
    head?.next?.next = head
    head?.next = nil
    
    return newHead
}

let list1 = ListNodeList(1)
list1.insert(2)
list1.insert(3)
list1.insert(4)
//list1.insert(5)
list1.insert(3)
list1.insert(2)
list1.insert(1)

reverse(head: list1.root)

isPalindrome(head: list1.root)

//: [Next](@next)
