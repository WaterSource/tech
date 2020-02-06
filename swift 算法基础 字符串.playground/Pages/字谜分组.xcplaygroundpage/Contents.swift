//: [Previous](@previous)

import Foundation

func groupAnagrams(_ strs: [String]) -> [[String]] {
    var tmpMap = [String:[String]]()
    
    for obj in strs {
        let tmp = String(Array(obj.sorted()))
        
        if let list = tmpMap[tmp] {
            tmpMap[tmp] = list + [obj]
        } else {
            var list = [String]()
            list.append(obj)
            tmpMap[tmp] = list
        }
    }
    
    return Array(tmpMap.values)
}

let input = ["eat", "tea", "tan", "ate", "nat", "bat"]
let output = groupAnagrams(input)
print(output)

//: [Next](@next)
