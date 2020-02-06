import UIKit

// 问题描述：从arr[1, n]这n个数中，找出最大的k个数，这就是经典的TopK问题。

// 方案一： 排序，取出最大的K个
// 方案二： 局部排序，通过冒泡，查找范围内最大的，O(k*n)
// 方案三： 堆，先用前k个元素通过生成小顶堆(二叉树，最小值在最顶端)，遍历后续元素，替换顶部后重新整理生成顶堆 O(n*lg(k))
// 方案四： 随机选择

func topK3(_ list: [Int], _ k: Int) -> [Int] {
    var heap = Heap<Int>.init { (f, s) -> Bool in
        return f < s
    }
    
    for i in list {
        heap.insert(i)
        if heap.count > k {
            heap.remove()
        }
    }
    
    print(heap)
    
    var array = [Int]()
    while heap.count > 0 {
        array.append(heap.peek()!)
        heap.remove()
    }
    return array
}

struct Heap<T> {
    public var nodes = [T]()
    public var orderCriteria: (T, T) -> Bool
    
    public init(sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
    }
    
    public init(arr: [T], sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
        configureHeep(from: arr)
    }
    
    public var isEmpty: Bool {
        return nodes.isEmpty
    }
    
    public var count: Int {
        return nodes.count
    }
    
    // @inline(__always) 汇编阶段直接内联，反编译
    @inline(__always) func parentIndex(ofIndex index: Int) -> Int {
        return (index - 1) / 2
    }
    
    func leftChildIndex(ofIndex index: Int) -> Int {
        return index * 2 + 1
    }
    
    func rightChildIndex(ofIndex index: Int) -> Int {
        return index * 2 + 2
    }
    
    public func peek() -> T? {
        return nodes.first
    }
    
    // mutating 在结构体中可以修改实例
    public mutating func configureHeep(from array: [T]) {
        nodes = array
        reset()
    }
    
    public mutating func reset() {
        for i in stride(from: nodes.count / 2 - 1, through: 0, by: -1) {
            shiftDown(i)
        }
    }
    
    internal mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let child = nodes[childIndex]
        var parentIndex = self.parentIndex(ofIndex: index)
        while childIndex > 0 && orderCriteria(child, nodes[parentIndex]) {
            nodes[childIndex] = nodes[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(ofIndex: childIndex)
        }
        nodes[childIndex] = child
    }
    
    internal mutating func shiftDown(from index: Int, until endIndex: Int) {
        let leftChildIndex = self.leftChildIndex(ofIndex: index)
        let rightChildIndex = self.rightChildIndex(ofIndex: index)
        
        var first = index
        if leftChildIndex < endIndex && orderCriteria(nodes[leftChildIndex], nodes[first]) {
            first = leftChildIndex
        }
        if rightChildIndex < endIndex && orderCriteria(nodes[rightChildIndex], nodes[first]) {
            first = rightChildIndex
        }
        if first == index {
            return
        }
        nodes.swapAt(index, first)
        shiftDown(from: first, until: endIndex)
    }
    
    internal mutating func shiftDown(_ index: Int) {
        shiftDown(from: index, until: nodes.count)
    }
    
    public mutating func insert(_ value: T) {
        nodes.append(value)
        shiftUp(nodes.count - 1)
    }
    
    public mutating func insert<S: Sequence>(_ sequence:S) where S.Iterator.Element == T {
        for value in sequence {
            insert(value)
        }
    }
    
    public mutating func replace(index i: Int, value: T) {
        guard i < nodes.count else {
            return
        }
        remove(at: i)
        insert(value)
    }
    
    // discardableResult 取消不适用返回值的警告
    @discardableResult
    public mutating func remove() -> T? {
        guard !nodes.isEmpty else {
            return nil
        }
        if nodes.count == 1 {
            return nodes.removeLast()
        } else {
            // 移除堆顶 重新排序
            let value = nodes[0]
            nodes[0] = nodes.removeLast()
            shiftDown(0)
            return value
        }
    }
    
    @discardableResult
    public mutating func remove(at index: Int) -> T? {
        guard index < nodes.count else { return nil}
        let size = nodes.count - 1
        if index != size {
            nodes.swapAt(index, size)
            shiftDown(from: index,  until: size)
            shiftUp(index)
        }
        return nodes.removeLast()
    }
    
    public mutating func sort() -> [T] {
        for i in stride(from: self.nodes.count - 1, to: 0, by: -1) {
            nodes.swapAt(0, i)
            shiftDown(from: 0, until: i)
        }
        return nodes
    }
}

// 1,2,3,4,5,6,7,9
var list3 = [4, 6, 1, 3, 2, 7, 9, 5]
let result3 = topK3(list3, 5)
result3

func topK4(_ list: inout [Int], _ left: Int, _ right: Int, _ k: Int) -> [Int] {
    guard k != list.count else {
        return list
    }
    
    if left == right {
        return Array(list[0..<k])
    }
    
    // 读取当次排序哨兵的位置
    let index = sortHelper4(&list, left, right)
    
    if index > k - 1 {
        return topK4(&list, left, index - 1, k)
    } else if index < k - 1 {
        return topK4(&list, index + 1, right, k)
    } else {
        return Array(list[0..<k])
    }
}

// 快速排序其中一部分，返回哨兵位置
func sortHelper4(_ list: inout [Int], _ left: Int, _ right: Int) -> Int {
    let pivotIndex = left
    let pivot = list[pivotIndex]
    
    var leftIndex = left
    var rightIndex = right
    
    while leftIndex < rightIndex {
        if list[rightIndex] > pivot {
            if list[leftIndex] < pivot {
                (list[leftIndex], list[rightIndex]) = (list[rightIndex], list[leftIndex])
            } else {
                leftIndex += 1
            }
        } else {
            rightIndex -= 1
        }
    }
    
    (list[pivotIndex], list[leftIndex]) = (list[leftIndex], list[pivotIndex])
    return leftIndex
}

var list4 = [4, 6, 1, 3, 2, 7, 9, 5]
let result4 = topK4(&list4, 0, list4.count-1, 5)
result4
