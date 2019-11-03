//: [Previous](@previous)

import Foundation

class ListNode {
    var val: Int?
    var next: ListNode?
    
    init(_ x: Int) {
        val = x
        next = nil
    }
    
    func printList() {
        var tmp: ListNode? = self
        while tmp != nil {
            print("node", tmp!.val!)
            tmp = tmp?.next
        }
    }
}

class ListNodeList {
    var root: ListNode?
    var head: ListNode?
    
    init(_ x: Int) {
        let node = ListNode(x)
        self.root = node
        self.head = node
    }
    
    func insert(_ x: Int) {
        let node = ListNode(x)
        head?.next = node
        head = node
    }
    
    func printAll() {
        var node: ListNode? = root
        while node != nil {
            print("node", node?.val ?? 0)
            node = node?.next
        }
    }
}

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
    
    print("=== fast")
    fast!.printList()
    
    print("=== slow1")
    slow!.printList()
    
    slow = reverse(head: slow?.next)
    
    print("=== slow2")
    slow!.printList()
    
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
        print("链路中没有下一个", head?.val)
        return head
    }
    
    print("当前是", head?.val)
    print("链路中下一个是", head?.next?.val)
    
    let newHead = reverse(head: head?.next)
    print("newHead", newHead?.val)
    print("当前是", head?.val)
    
    head?.next?.next = head
    print("重置链表关系", "head next", head?.next?.val, "head.next.next", head?.next?.next?.val)
    
    head?.next = nil
    
    return newHead
}

let list1 = ListNodeList(1)
list1.insert(2)
list1.insert(3)
list1.insert(4)
list1.insert(5)
//list1.insert(3)
//list1.insert(2)
//list1.insert(1)

reverse(head: list1.root)

//isPalindrome(head: list1.root)

//: [Next](@next)
