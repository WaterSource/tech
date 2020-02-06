//: [Previous](@previous)

import Foundation

struct Heap<T> {
    // 数据源
    public var nodes = [T]()
    
    // 排序规则，决定是大顶堆还是小顶堆
    public var orderCriteria: (_ child: T, _ parant: T) -> Bool
    
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
    
    // @inline(__always) 汇编阶段直接内联，有效反编译
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
    
    // 按照排序规则，上浮节点
    internal mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let child = nodes[childIndex]
        var parentIndex = self.parentIndex(ofIndex: index)
        
        // 遍历找到满足排序规则的父节点
        while childIndex > 0 && orderCriteria(child, nodes[parentIndex]) {
            // 父节点的值下放到子节点
            nodes[childIndex] = nodes[parentIndex]
            // 切换指针到父节点
            childIndex = parentIndex
            // 更新父节点指针
            parentIndex = self.parentIndex(ofIndex: childIndex)
        }
        
        // 将原子节点的值赋值到最后的遍历节点
        nodes[childIndex] = child
    }
    
    // 按照排序规则，下沉节点
    internal mutating func shiftDown(from index: Int, until endIndex: Int) {
        let leftChildIndex = self.leftChildIndex(ofIndex: index)
        let rightChildIndex = self.rightChildIndex(ofIndex: index)
        
        var first = index
        
        // 左子树节点在限制范围内，满足排序规则
        if leftChildIndex < endIndex && orderCriteria(nodes[leftChildIndex], nodes[first]) {
            first = leftChildIndex
        }
        
        // 右子树节点优先于左子树节点
        if rightChildIndex < endIndex && orderCriteria(nodes[rightChildIndex], nodes[first]) {
            first = rightChildIndex
        }
        
        // 如果没有满足条件的子节点，结束
        if first == index {
            return
        }
        
        // 交换父节点和满足条件的子节点
        nodes.swapAt(index, first)
        
        // 递归调用
        shiftDown(from: first, until: endIndex)
    }
    
    internal mutating func shiftDown(_ index: Int) {
        shiftDown(from: index, until: nodes.count)
    }
    
    /// 增加元素，重新排序
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
            // 和队尾交换
            nodes.swapAt(index, size)
            // 此时index是原先队尾的值
            // 从index向下重新排序
            shiftDown(from: index,  until: size)
            // 从index向上重新排序
            shiftUp(index)
        }
        
        // 移除队尾
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

func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
    var heap = Heap<(Int, Int)>.init { (f, s) -> Bool in
        return f.1 < s.1
    }
    var dict = [Int: Int]()
    for i in nums {
        dict[i] = (dict[i] ?? 0) + 1
    }
    
    for i in dict {
        heap.insert(i)
        if heap.count > k {
            heap.remove()
        }
    }
    
    print(heap)
    
    var array = [Int]()
    while heap.count > 0 {
        array.append(heap.peek()!.0)
        heap.remove()
    }
    return array.reversed()
}

let test = [2,3,3,1,3,2,3]
let result = topKFrequent(test, 2)
result

//: [Next](@next)
