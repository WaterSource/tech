//: [Previous](@previous)

import Foundation

/*
 方案一
 三重循环，需要注意重复数字的过滤
 O(n*n*n)
 
 方案二
 用hash表储存每个数字出现的次数，排序后，依次处理3个数字相同，2个数字相同，不相同的场景
 生成hash表 O(n)
 排序 O(nlogn)
 遍历 O(n*n)
 
 方案三
 指针对撞，排序后遵循以下规则
 1. 首位不大于0
 2. 首位跳过重复数字
 3. 确定首位之后，设置两个指针指向i+1,队尾并逐渐靠近
 4. 第二位和第三位遇到重复数字需要跳过
 排序 O(nlogn)
 遍历对撞 O(n*n)
 没有使用额外空间 O(1)O(1)O(1)
 */

func threeSumA(_ nums: [Int]) -> [[Int]] {
    let size = nums.count
    var result = [[Int]]()
    let nums_sort = nums.sorted()
    
    for firstIndex in 0..<size {
        // 因为已经排过序了，所以首个数字只考虑小于0的情况
        if nums_sort[firstIndex] > 0 {
            break
        }
        
        // 如果当前和上一个相同，可以过滤
        if firstIndex > 0, nums_sort[firstIndex] == nums_sort[firstIndex - 1] {
            continue
        }
        
        // 在首位数之后查找
        for secondIndex in firstIndex+1..<size {
            
            if nums_sort[firstIndex] + nums_sort[secondIndex] > 0 {
                break
            }
            
            if secondIndex > firstIndex+1,
                nums_sort[secondIndex] == nums_sort[secondIndex - 1] {
                continue
            }
            
            for thirdIndex in secondIndex+1..<size {
                
                if nums_sort[firstIndex] + nums_sort[secondIndex] + nums_sort[thirdIndex] > 0 {
                    break
                }
                
                if thirdIndex > secondIndex+1,
                    nums_sort[thirdIndex] == nums_sort[thirdIndex-1] {
                    continue
                }
                
                if nums_sort[firstIndex] + nums_sort[secondIndex] + nums_sort[thirdIndex] == 0 {
                    result.append([nums_sort[firstIndex], nums_sort[secondIndex], nums_sort[thirdIndex]])
                }
            }
        }
    }
    
    return result
}

func threeSumB(_ nums: [Int]) -> [[Int]] {
    var hashMap = [Int: Int]()
    for obj in nums {
        if let tmp = hashMap[obj] {
            hashMap[obj] = tmp + 1
        } else {
            hashMap[obj] = 1
        }
    }
    
    var result = [[Int]]()
    
    // 处理3个相同
    if let tmp = hashMap[0], tmp >= 3 {
        result.append([0, 0, 0])
    }
    
    // 键值排序
    let sort_key = hashMap.keys.sorted()
    
    for firstIndex in 0..<sort_key.count {
        for secondIndex in firstIndex+1..<sort_key.count {
            
            let firstObj = sort_key[firstIndex]
            let firstCount = hashMap[firstObj]!
            
            let secondObj = sort_key[secondIndex]
            let secondCount = hashMap[secondObj]!
            
            // 两个相同1
            if firstObj * 2 + secondObj == 0, firstCount >= 2 {
                result.append([firstObj, firstObj, secondObj])
            }
            
            // 两个相同2
            if firstObj + secondObj * 2 == 0, secondCount >= 2 {
                result.append([firstObj, secondObj, secondObj])
            }
            
            // 不相同
            let thirdObj = 0 - firstObj - secondObj
            if thirdObj > secondObj,
                let _ = hashMap[thirdObj] {
                result.append([firstObj, secondObj, thirdObj])
            }
        }
    }
    return result
}

func threeSumC(_ nums: [Int]) -> [[Int]] {
    let sort_nums = nums.sorted()
    var result = [[Int]]()
    
    for firstIndex in 0..<sort_nums.count-2 {
        let firstObj = sort_nums[firstIndex]
        // 首位只检测小于0部分
        if firstObj > 0 {
            break
        }
        // 跳过重复数字
        if firstIndex > 0,
            sort_nums[firstIndex] == sort_nums[firstIndex-1] {
            continue
        }
        
        var secondIndex = firstIndex+1
        var thirdIndex = sort_nums.count-1
        
        while secondIndex < thirdIndex {
            let secondObj = sort_nums[secondIndex]
            let thirdObj = sort_nums[thirdIndex]
            let tmp = firstObj + secondObj + thirdObj

            if tmp == 0 {
                result.append([firstObj, secondObj, thirdObj])
                secondIndex += 1
                thirdIndex -= 1
                
                // 跳过重复数字
                while secondIndex < thirdIndex, sort_nums[secondIndex] == sort_nums[secondIndex - 1] {
                    secondIndex += 1
                }
                
                while secondIndex < thirdIndex, sort_nums[thirdIndex] == sort_nums[thirdIndex - 1] {
                    thirdIndex -= 1
                }
            } else if tmp < 0 {
                secondIndex += 1
                
                while secondIndex < thirdIndex, sort_nums[secondIndex] == sort_nums[secondIndex - 1] {
                    secondIndex += 1
                }
                
            } else {
                thirdIndex -= 1
                
                while secondIndex < thirdIndex, sort_nums[thirdIndex] == sort_nums[thirdIndex - 1] {
                    thirdIndex -= 1
                }
            }
        }
    }
    
    return result
}

let test1 = [-1, 0, 1, 2, -1, -4]
print(threeSumC(test1))

//: [Next](@next)
