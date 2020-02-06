//: [Previous](@previous)

import Foundation

// 判断链表是否有环
// 快慢指针，看是否会有相同

// 扩展 环的相交点
// 在相交之后，从起点在发出一个慢指针，两个慢指针继续步进，再次相交的位置为环的相交点

// 原理 假设slow走了s步，fast走了2s步，fast在环内循环n圈，环长为r; 链表长L，环入口与相遇点距离x，起点到环入口点的距离为a;
// 2s = s + nr
// s = a + x
// L = a + r
// 变换后有 a = (n-1)r + (L-a-x)
// 其中 L-a-x 为原慢指针再次到达环起点的距离，所以再次相遇点为环起点

func hasCycle(_ head: ListNode?) -> Bool {
    guard let head = head else {
        return false
    }
    
    var fast: ListNode? = head
    var slow: ListNode? = head
    
    while fast?.next != nil, fast?.next?.next != nil {
        fast = fast?.next?.next
        slow = slow?.next
        
        if let fast = fast, let slow = slow,
            fast === slow {
            return true
        }
    }
    
    return false
}

//: [Next](@next)
