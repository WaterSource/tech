import UIKit

/*
写一个程序，输出从 1 到 n 数字的字符串表示。
1. 如果 n 是3的倍数，输出“Fizz”；
2. 如果 n 是5的倍数，输出“Buzz”；
3.如果 n 同时是3和5的倍数，输出 “FizzBuzz”。
*/

func fizzBuzz(_ n: Int) -> [String] {
    var result = [String]()
    for index in 1...n {
        if index%3 == 0,
            index%5 == 0 {
            result.append("FizzBuzz")
        } else if index%3 == 0 {
            result.append("Fizz")
        } else if index%5 == 0 {
            result.append("Buzz")
        } else {
            result.append("\(index)")
        }
    }
    
    return result
}
