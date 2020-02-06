import UIKit

func hanmingWeight(_ n: UInt32) -> Int {
    
    var num = 0
    var tmp = n
    
    while tmp != 0 {
        tmp = tmp&(tmp-1)
        num += 1
    }
    return num
}

hanmingWeight(11)
