//: [Previous](@previous)

import Foundation

var nums = [1, 2]
let k = 3

func rotate(_ nums: inout [Int], _ k: Int) {
    guard nums.count > 1 else {
        return
    }
    
    let k = k > nums.count ? k % nums.count : k
    
    nums = nums.reversed()
    for i in 0..<(k/2) {
        if i != k-i-1 {
            (nums[i], nums[k-i-1]) = (nums[k-i-1], nums[i])
        }
    }
    
    for i in 0..<(nums.count-k)/2 {
        if k+i != nums.count-i-1 {
            (nums[k+i], nums[nums.count-i-1]) = (nums[nums.count-i-1], nums[k+i])
        }
    }
}

rotate(&nums, k)
print(nums)

//: [Next](@next)


func rotateB(_ nums: inout [Int], _ k: Int) {
    let times = k % nums.count
    if times == 0 {
        return;
    }
    // //         方法一
    //         let suffixArray = nums.suffix(times)
    //         nums.removeSubrange(nums.count - times..<nums.count)
    //         nums.insert(contentsOf: suffixArray, at: 0)
    
    // //         方法二
    //         var i: Int = 0
    //         while i < times {
    //             var j = nums.count - 1
    //             let temp = nums[nums.count - 1]
    //             while j > 0 {
    //                 nums[j] = nums[j - 1]
    //                 j -= 1
    //             }
    //             nums[0] = temp
    //             i += 1
    //         }
    
    //         方法三
    reverse(&nums, 0, nums.count - 1)
    reverse(&nums, 0, times - 1)
    reverse(&nums, times, nums.count - 1)
}

func reverse(_ nums: inout [Int], _ start: Int, _ end: Int) {
    var s = start, e = end
    while s < e {
        var temp = nums[s]
        nums[s] = nums[e]
        nums[e] = temp
        s += 1
        e -= 1
    }
}
