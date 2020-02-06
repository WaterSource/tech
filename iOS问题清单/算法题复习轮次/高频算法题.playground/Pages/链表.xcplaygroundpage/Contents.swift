//: [Previous](@previous)

import Foundation

class ListNode {
    let val: Int
    var next: ListNode?
    
    init(_ val: Int) {
        self.val = val
    }
}

func printAllList(_ list: ListNode?) {
    guard let list = list else {
        return
    }
    print(list.val)
    printAllList(list.next)
}

// 1. 生成链表

func createList(_ list: [Int]) -> ListNode? {
    guard list.count > 0 else {
        return nil
    }
    
    let node = ListNode(0)
    var head = node
    
    for val in list {
        head.next = ListNode(val)
        head = head.next!
    }
    
    return node.next
}

// 2. 链表倒转

func reverseList(_ node: ListNode) -> ListNode {
    
    var last: ListNode? = node
    var head: ListNode? = node.next
    last?.next = nil
    
    while head != nil {
        let tmp = head?.next
        head!.next = last
        last = head
        head = tmp
    }
    
    return last!
}

func reverseListB(_ node: ListNode) -> ListNode {
    let root = ListNode(0)
    root.next = node
    
    let head: ListNode? = node
    
    while head?.next != nil {
        // 取出下一个 n1
        let next = head?.next
        // 和再下一个先链上 n2
        head?.next = next?.next
        
        // 将n1 插入root后
        next?.next = root.next
        root.next = next
    }
    
    return root.next!
}

// 3. 链表共同节点

func sameNode(_ listA: ListNode, _ listB: ListNode) -> ListNode? {
    
    var headA: ListNode? = listA
    var headB: ListNode? = listB
    
    var circleA = false
    var circleB = false
    
    while headA != nil, headB != nil {
        
        if headA?.val == headB?.val {
            return headA
        }
        
        headA = headA?.next
        headB = headB?.next
        
        if headA == nil, !circleA {
            headA = listB
            circleA = true
        }
        
        if headB == nil, !circleB {
            headB = listA
            circleB = true
        }
    }
    
    return nil
}

// 4. 环的位置

// 再相遇之后，再启动一个慢指针从起始点步进，两个慢指针相遇点为入口

func circleNode(_ list: ListNode) -> ListNode? {
    var fast: ListNode? = list
    var slow: ListNode? = list
    
    while fast?.next != nil, fast?.next?.next != nil {
        fast = fast?.next?.next
        slow = slow?.next
        
        if let fast = fast,
            let slow = slow,
            fast === slow {
            
            var slow1: ListNode? = slow
            var slow2: ListNode? = list
            while true {
                slow1 = slow1?.next
                slow2 = slow2?.next
                
                if slow1! === slow2! {
                    return slow1
                }
            }
        }
    }
    
    return nil
}

// test

let root = [1, 2, 3, 4, 5]
let resultA = createList(root)
//printAllList(resultA)
//
//let resultB = reverseList(resultA!)
//printAllList(resultB)

let rootC = [10, 9, 8, 4, 5];
let resultC = createList(rootC)

//: [Next](@next)
