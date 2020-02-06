import UIKit

// 洗牌算法
// 只利用一次循环等概率的取到不同的元素
// 如果元素存在于数组中，即可将每次random的元素与最后一个元素交换，然后count--

func random(_ datasource: [Int]) -> [Int] {
    var result = datasource
    var count: Int = datasource.count
    
    for _ in 0..<datasource.count {
        let random = Int(arc4random())%count
        (result[random], result[count-1]) = (result[count-1], result[random])
        count -= 1
    }
    
    return result
}

let list = [1, 2, 3, 4, 5, 6, 7, 8]

for _ in 0..<10 {
    print(random(list))
}

