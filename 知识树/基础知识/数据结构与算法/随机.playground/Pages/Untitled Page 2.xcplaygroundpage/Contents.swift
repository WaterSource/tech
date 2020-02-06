//: [Previous](@previous)

import Foundation
import UIKit



var mutableArray = [1,2,3]
for obj in mutableArray {
    print("1", obj)
    let tmp = mutableArray.removeLast()
    print("2", tmp)
}

let test1 = ["1", "@", "2"].map{Int($0)}
let a = test1[0]

var test = [1, 2, 3]
var test2 = test.filter{ $0%2 == 0 }

var test3 = ["1", "2", "3"]

print(Unmanaged.passUnretained(test as AnyObject).toOpaque())
print(Unmanaged.passUnretained(test2 as AnyObject).toOpaque())
print(Unmanaged.passUnretained(test3 as AnyObject).toOpaque())

test = [3, 4, 5]
print(Unmanaged.passUnretained(test as AnyObject).toOpaque())
print(Unmanaged.passUnretained(test2 as AnyObject).toOpaque())

let test4 = (0..<10).reduce("初始值"){$0 + "\($1)"}
test4

let arr = [[1],[2,3],[4,5,6]]
let result = arr.flatMap{$0}
result

class TestClass {
    public func foo() {
        
    }
    
    open func bar() {
        
    }
}

class TestClass2: TestClass {
    override func foo() {
        
    }
    
    override func bar() {
        
    }
}

//: [Next](@next)
