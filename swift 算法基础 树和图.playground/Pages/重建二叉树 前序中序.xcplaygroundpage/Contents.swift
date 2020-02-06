//: [Previous](@previous)

import Foundation

func buildTree(_ perorder: [Int], _ inorder: [Int]) -> TreeNode? {
    
    guard perorder.count > 0, inorder.count > 0 else {
        return nil
    }
    
    let root = rebuildHelper(perorder, 0, perorder.count-1, inorder, 0, inorder.count-1)
    return root
}

func rebuildHelper(_ perorder:[Int], _ perStart: Int, _ perEnd: Int, _ inorder: [Int], _ inStart: Int, _ inEnd: Int) -> TreeNode? {
    
    guard perStart <= perEnd, inStart <= inEnd else {
        return nil
    }
    
    let rootVal = perorder[perStart]
    let root = TreeNode(rootVal)
    
    for index in inStart...inEnd {
        let inVal = inorder[index]
        if rootVal == inVal {
            let leftTreeLength = index-inStart
            
            root.left = rebuildHelper(perorder, perStart+1, perStart+leftTreeLength, inorder, inStart, index-1)
            root.right = rebuildHelper(perorder, perStart+leftTreeLength+1, perEnd, inorder, index+1, inEnd)
            
            break
        }
    }
    
    return root
}

// 根左右
let perorder = [3,9,20,15,7]
// 左根右
let inorder = [9,3,15,20,7]

let result = buildTree(perorder, inorder)
print(result!.levelorder())

//: [Next](@next)
