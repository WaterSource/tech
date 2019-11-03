import UIKit

class ListNode {
    var val: Int
    var next: ListNode?
    
    init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    
    func description() {
        var tmp: ListNode? = self
        var index: Int = 0
        
        while tmp != nil {
            print("index=", index, "val=", tmp!.val)
            index += 1
            tmp = tmp!.next
        }
    }
}

class List {
    var head: ListNode?
    var tail: ListNode?
    
    // 尾插法
    func appendToTail(_ val: Int) {
        if tail == nil {
            tail = ListNode(val)
            head = tail
        } else {
            tail!.next = ListNode(val)
            tail = tail!.next
        }
    }
    
    // 头插法
    func appendToHead(_ val: Int) {
        if head == nil {
            head = ListNode(val)
            tail = head
        } else {
            let temp = ListNode(val)
            temp.next = head
            head = temp
            
        }
    }
}

let testListNode = ListNode(0)
var pre: ListNode? = testListNode
for index in 1..<6 {
    pre!.next = ListNode(index)
    pre = pre!.next
}

// 给一个链表和一个值x，要求将链表中所有小于x的值放到左边，所有大于等于x的值放到右边。原链表的节点顺序不能变。
// 例：1->5->3->2->4->2，给定x = 3。则我们要返回 1->2->2->5->3->4

func getLeftList(_ head: ListNode?, _ x: Int) -> ListNode? {
    let dummy = ListNode(0)
    var pre = dummy
    var node = head
    
    while node != nil {
        if node!.val < x {
            pre.next = node
            pre = node!
        }
        
        node = node!.next
    }
    
    node?.next = nil
    return dummy.next
}

// 解题思路，设置左右两个链表，小于指定值的插入左侧链表，大于指定值的插入右侧链表，最后组装
func partition(_ head: ListNode?, _ x: Int) -> ListNode? {
    let dummy_pre = ListNode(0)
    let dummy_post = ListNode(0)
    
    var pre = dummy_pre
    var post = dummy_post
    
    var node = head
    
    while node != nil {
        if node!.val < x {
            pre.next = node
            pre = node!
        } else {
            post.next = node
            post = node!
        }
        
        node = node!.next
    }
    
    pre.next = dummy_post.next
    post.next = nil
    
    return dummy_pre.next
}

// 链表 快行指针

// 检查链表是否有环

// 使用两个指针访问链表，一个移动速度快一个速度慢(一个在前一个在后)，一旦重合则存在链表环
func hasCycle(_ head:  ListNode?) -> Bool {
    var slow = head
    var fast = head
    
    while fast != nil && fast!.next != nil {
        slow = slow!.next
        fast = fast!.next!.next
        
        if slow === fast {
            return true
        }
    }
    
    return false
}

// 例题
// 删除链表中倒数第N个节点

func removeNthFromEnd(head: ListNode?, _ n: Int) -> ListNode? {
    guard let head = head else {
        return nil
    }
    
    let dummy = ListNode(0)
    dummy.next = head
    
    var prev: ListNode? = dummy
    var post: ListNode? = dummy
    
    // 设置后一个节点初始位置
    for _ in 0..<n {
        if post == nil {
            break
        }
        post = post!.next
    }
    
    // 同时移动前后节点
    while post != nil, post!.next != nil {
        prev = prev!.next
        post = post!.next
    }
    
    // 删除节点
    prev!.next = nil
    
    return dummy.next
}

testListNode.description()

removeNthFromEnd(head: testListNode, 3)?.description()
