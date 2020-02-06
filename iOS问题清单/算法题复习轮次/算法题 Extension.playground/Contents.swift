import UIKit

// 找到view的共同父类

func findCommonSuperView(_ view1: UIView, _ view2: UIView) -> UIView? {
    
    var tmp: UIView? = view1
    
    while tmp != nil {
        // view2 是否是 tmp 的子视图
        if view2.isDescendant(of: tmp!) {
            return tmp
        }
        
        tmp = tmp?.superview
    }
    
    return nil
    
    
}

// 两个数组找出不同的元素

func findDifferent(_ list1:[Int], _ list2: [Int]) -> [Int]? {
    guard list1.count > 0, list2.count > 0 else {
        return nil
    }
    
    let set1 = Array(Set(list1))
    let set2 = Array(Set(list2))
    
    let sumList = (set1 + set2).sorted()
    
    var tmpDic = [Int: Int]()
    
    for item in sumList {
        if tmpDic[item] != nil {
            tmpDic.removeValue(forKey: item)
        } else {
            tmpDic[item] = item
        }
    }
    
    return Array(tmpDic.keys)
}

let list1 = [1,1,2,3,4]
let list2 = [0,1,2,3]
let list3 = findDifferent(list1, list2)
list3
