import UIKit

class Solution {
    private var origin_list: [Int]
    
    init(_ nums: [Int]) {
        origin_list = nums
    }
    
    func reset() -> [Int] {
        var count = origin_list.count
        var result = origin_list
        
        Int.random(in: 0..<count)
        
        for _ in origin_list {
            
            let random = Int(arc4random())%count
            (result[random], result[count-1]) = (result[count-1], result[random])
            count-=1
        }
        return result
    }
    
    func shuffle() -> [Int] {
        return origin_list
    }
}
