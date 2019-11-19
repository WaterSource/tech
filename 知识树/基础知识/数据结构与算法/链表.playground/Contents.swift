//: A MapKit based Playground

import Foundation

class ListNode {
    var val: Int?
    var next: ListNode?
    
    init(_ val: Int?) {
        self.val = val
    }
}

class NodeList {
    var root: ListNode?
    var head: ListNode?
    
    init(_ val: Int?) {
        let node = ListNode(val)
        self.root = node
        self.head = node
    }
    
    init(_ root: ListNode?) {
        self.root = root
        self.head = root
    }
    
    func insertNode(_ val: Int?)  {
        let node = ListNode(val)
        self.head?.next = node
    }
    
    func insertNode(_ node: ListNode?) {
        self.head?.next = node
    }
    
    class func printAll(_ root: ListNode) -> [Int] {
        var result = [Int]()
        
        var headNode: ListNode? = root
        var index: Int = 0
        
        while headNode != nil {
            if let nodeVal = headNode?.val {
                print("index=\(index)", "val=\(nodeVal)")
                result.append(nodeVal)
            }
            
            headNode = headNode?.next
            index += 1
        }
        
        return result
    }
}


// 单链表翻转

func reverseListA(_ head: ListNode?) -> ListNode? {
    guard head != nil,
        head?.next != nil else {
            return head
    }
    
    let tmp = reverseListA(head?.next)
    head?.next?.next = head
    head?.next = nil
    
    return tmp
}

func reverseListB(_ head: ListNode?) -> ListNode? {
    var curr: ListNode? = head
    
    if curr == nil {
        return nil
    }
    
    var prev: ListNode? = nil
    var temp: ListNode? = nil
    
    while curr != nil {
        temp = curr?.next
        curr?.next = prev
        prev = curr
        curr = temp
    }
    
    return prev
}

// 单链表是否有环

func hasCycleA(_ head: ListNode?) -> Bool {
    guard head != nil else {
        return false
    }
    
    var tmpDic = [Int: Int]()
    
    if let headVal = head?.val {
        if tmpDic[headVal] != nil {
            return true
        } else {
            tmpDic[headVal] = 1
        }
    }
    
    return false
}

func hasCycleB(_ head: ListNode?) -> Bool {
    guard head != nil else {
        return false
    }
    
    var fast: ListNode? = head
    var slow: ListNode? = head
    
    while fast != nil && fast?.next != nil {
        slow = slow?.next
        fast = fast?.next?.next
        
        if slow === fast {
            return true
        }
    }
    return false
}

// 单链表找环入口

// fast = L(表头到环入口距离) + X(环入口到相遇点距离) + n*R(环的长度，已经走了n圈)
// slow = L + X
// fast = 2*slow
// L = R - X [必然是慢指针在环内相遇]

func detectCycle(_ head: ListNode?) -> ListNode? {
    guard head != nil else {
        return nil
    }
    
    var fast: ListNode? = head
    var slow1: ListNode? = head
    var slow2: ListNode? = head
    
    while fast != nil && fast?.next != nil {
        fast = fast?.next?.next
        slow1 = slow1?.next
        
        if slow1 === fast {
            while slow2 !== slow1 {
                slow1 = slow1?.next
                slow2 = slow2?.next
            }
            return slow2
        }
    }
    
    return nil
}

// 单链表找交点

func getIntersectionNode(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
    
    var pa = headA
    var pb = headB
    
    while pa !== pb {
        pa = pa != nil ? pa?.next : headB
        pb = pb != nil ? pb?.next : headA
    }
    
    return pa
}

// 单链表找中点

func middleNode(_ head: ListNode?) -> ListNode? {
    guard head != nil else {
        return nil
    }
    
    var fast = head
    var slow = head
    
    while fast != nil, fast?.next != nil {
        fast = fast?.next?.next
        slow = slow?.next
    }
    
    return slow
}

// 单链表合并

func mergeTwoLists(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
    guard headA != nil else {
        return headB
    }
    
    guard headB != nil else {
        return headA
    }
    
    let root = ListNode(0)
    var head: ListNode? = root
    var tmpA = headA
    var tmpB = headB
    
    while tmpA != nil && tmpB != nil {
        if let valueA = tmpA?.val,
            let valueB = tmpB?.val {
            
            if valueA < valueB {
                head?.next = tmpA
                tmpA = tmpA?.next
            } else {
                head?.next = tmpB
                tmpB = tmpB?.next
            }
        }
        head = head?.next
    }
    head?.next = tmpA != nil ? tmpA : tmpB
    return root.next
}

// Test

let list = NodeList(1)
list.insertNode(2)
list.insertNode(3)
list.insertNode(4)
list.insertNode(5)
list.insertNode(6)
list.insertNode(7)
list.insertNode(8)

//list.root



NodeList.printAll(list.root!)
