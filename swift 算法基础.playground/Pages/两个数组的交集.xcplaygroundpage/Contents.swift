//: [Previous](@previous)

import Foundation

let nums1 = [61,24,20,58,95,53,17,32,45,85,70,20,83,62,35,89,5,95,12,86,58,77,30,64,46,13,5,92,67,40,20,38,31,18,89,85,7,30,67,34,62,35,47,98,3,41,53,26,66,40,54,44,57,46,70,60,4,63,82,42,65,59,17,98,29,72,1,96,82,66,98,6,92,31,43,81,88,60,10,55,66,82,0,79,11,81]
let nums2 = [5,25,4,39,57,49,93,79,7,8,49,89,2,7,73,88,45,15,34,92,84,38,85,34,16,6,99,0,2,36,68,52,73,50,77,44,61,48]

func intersect(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
    
    guard nums1.count > 0, nums2.count > 0 else {
        return []
    }
    
    var result = [Int]()
    
    var nums1 = nums1.sorted()
    var nums2 = nums2.sorted()
    
    if nums1.count < nums2.count {
        (nums1, nums2) = (nums2, nums1)
    }
    
    print(nums1)
    print(nums2)
    
    var index1 = 0
    var index2 = 0
    
    while index1 < nums1.count {
        let tmp = nums1[index1]
        print("nums1 当前是在\(index1)的\(tmp)")
        
        print("nums2 当前index2是\(index2)")
        for i in index2..<nums2.count {
            if tmp == nums2[i] {
                result.append(tmp)
                index2 = i+1
                
                print("nums2 识别到在\(index1)的\(tmp) 和在\(i)的\(nums2[i]) 相同")
                print("现在index2为\(index2)")
                
                break
            }
        }
        
        index1 += 1
    }
    
    return result
}

//print(intersect(nums1, nums2))
//
//let re = [5,4,57,79,7,89,88,45,34,92,38,85,6,0,77,44,61]
//print(re.sorted())

func intersectB(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
    
    var ans = [Int]()
    
    let sets1 = Set<Int>(nums1)
    let sets2 = Set<Int>(nums2)
    // 交集
    let inter = sets1.intersection(sets2)
    
    var dic1 = [Int: Int]()
    var dic2 = dic1
    for n in nums1 {
        dic1[n, default: 0] += 1
    }
    for n in nums2 {
        dic2[n, default: 0] += 1
    }
    
    for v in inter {
        let ct = min(dic1[v]!, dic2[v]!)
        for _ in 0..<ct {
            ans.append(v)
        }
    }
    return ans
    
}

//print(intersectB(nums1, nums2))
//let re = [5,4,57,79,7,89,88,45,34,92,38,85,6,0,77,44,61]
//print(re.sorted())

func intersectC(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
//    var nums1 = nums1
//    var nums2 = nums2
//    if nums1.count > nums2.count {
//        (nums1, nums2) = (nums2, nums1)
//    }
    
    var dic = [Int: Int]()
    
    for obj in nums1 {
        dic[obj] = (dic[obj] ?? 0) + 1
    }
    
    var res = [Int]()
    for obj in nums2 {
        if let tmp = dic[obj], tmp > 0 {
            res.append(obj)
            dic[obj] = tmp - 1
        }
    }
    return res
}

print(intersectC(nums1, nums2).sorted())
let re = [5,4,57,79,7,89,88,45,34,92,38,85,6,0,77,44,61]
print(re.sorted())

//: [Next](@next)
