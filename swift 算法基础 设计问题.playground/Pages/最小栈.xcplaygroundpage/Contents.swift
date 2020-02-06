//: [Previous](@previous)

import Foundation

class MinStack {
    
    var stack = [Int]()
    var minStack = [Int]()
    
    init() {
        
    }
    
    func push(_ x: Int) {
        stack.append(x)
        
        if minStack.isEmpty {
            minStack.append(x)
        } else {
            let tmp = minStack.last!
            minStack.append(min(tmp, x))
        }
    }
    
    func pop() {
        guard stack.count > 0 else {
            return
        }
        
        stack.removeLast()
        minStack.removeLast()
    }
    
    func top() -> Int {
        if let last = stack.last {
            return last
        } else {
            return 0
        }
    }
    
    func getMin() -> Int {
        guard minStack.count > 0 else {
            return 0
        }
        
        return minStack.last!
    }
}

//: [Next](@next)
