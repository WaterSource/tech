//: [Previous](@previous)

import Foundation

func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
    
    nums1.replaceSubrange(m..<m+n, with: nums2)
    nums1.sort()
}

var num1 = [1,2,3,0,0,0]
let num2 = [2,5,6], m = 3, n = 3

merge(&num1, m, num2, n)

func mergeB(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
    
    var i = m - 1, j = n - 1
    while i >= 0 || j >= 0 {
        // 从后往前排，找到最大的数
        // 短数组结束之后直接使用长数组
        if j < 0 || (i >= 0 && nums1[i] > nums2[j]) {
            nums1[i + j + 1] = nums1[i]
            i -= 1
        } else {
            nums1[i + j + 1] = nums2[j]
            j -= 1
        }
    }
}

//: [Next](@next)
