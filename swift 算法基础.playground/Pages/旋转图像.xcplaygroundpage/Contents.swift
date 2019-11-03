//: [Previous](@previous)

import Foundation

var matrix =
[
    [1,2,3],
    [4,5,6],
    [7,8,9]
]

let result =
[
    [7,4,1],
    [8,5,2],
    [9,6,3]
]

func rotate(_ matrix: inout [[Int]]) {
    for i in 0..<matrix.count {
        for j in (i+1)..<matrix[i].count {
            (matrix[i][j], matrix[j][i]) = (matrix[j][i], matrix[i][j])
        }
        
        matrix[i].reverse()
    }
}

print(matrix)
rotate(&matrix)
print(matrix)

//: [Next](@next)
