//: [Previous](@previous)

import Foundation

var str: [[Character]] = [
    ["4","3",".",".","7",".",".",".","."],
    ["6",".",".","1","9","5",".",".","."],
    [".","9","8",".",".",".",".","6","."],
    ["8",".",".",".","6",".",".",".","3"],
    ["4",".",".","8",".","3",".",".","1"],
    ["7",".",".",".","2",".",".",".","6"],
    [".","6",".",".",".",".","2","8","."],
    [".",".",".","4","1","9",".",".","5"],
    [".",".",".",".","8",".",".","7","9"]
]

func isValidSudoku(_ board: [[Character]]) -> Bool {
    for i in 0..<board.count {
        // 行
        let row = board[i]
        if !isValid(row) {
            return false
        }
        
        // 列
        var line = [Character]()
        for j in 0..<9 {
            let tmp = board[j][i]
            line.append(tmp)
        }
        
        if !isValid(line) {
            return false
        }
    }
    
    // 格
    for i in 0..<3 {
        for j in 0..<3 {
            let part = [board[i*3][j*3], board[i*3][j*3+1], board[i*3][j*3+2],
            board[i*3+1][j*3], board[i*3+1][j*3+1], board[i*3+1][j*3+2],
            board[i*3+2][j*3], board[i*3+2][j*3+1], board[i*3+2][j*3+2]]
            
            if !isValid(part) {
                return false
            }
        }
    }
    
    return true
}

func isValid(_ list: [Character]) -> Bool {
    var dic = [String: Int]()
    for i in list {
        if i != "." {
            if dic[String(i)] != nil {
                return false
            }
            dic[String(i)] = 1
        }
    }
    return true
}

isValidSudoku(str)

func isValidSudokuB(_ board: [[Character]]) -> Bool {
    
    var row = Array(repeating: [Character: Int](), count: 9)
    var col = Array(repeating: [Character: Int](), count: 9)
    var box = Array(repeating: [Character: Int](), count: 9)
    
    for i in 0..<9 {
        for j in 0..<9 {
            
            let value = board[i][j]
            
            guard value != "." else {
                continue
            }
            
            var rowMap = row[i]
            if let count = rowMap[value], count > 0 {
                return false
            } else {
                rowMap[value] = 1
                row[i] = rowMap
            }
            
            var colMap = col[j]
            if let count = colMap[value], count > 0 {
                return false
            } else {
                colMap[value] = 1
                col[j] = colMap
            }
            
            let areaIndex = (i / 3) * 3 + j / 3
            var boxMap = box[areaIndex]
            if let count = boxMap[value], count > 0 {
                return false
            } else {
                boxMap[value] = 1
                box[areaIndex] = boxMap
            }
        }
    }
    return true
}

//: [Next](@next)
