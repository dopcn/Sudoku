//
//  main.swift
//  Sudoku
//
//  Created by 纬洲 冯 on 12/30/15.
//  Copyright © 2015 dopcn. All rights reserved.
//

import Foundation

enum SudokuError: ErrorType {
    case initDataError
    case invalidSudoku
    case subscriptOutOfRange
}

struct Sudoku: CustomStringConvertible {
    
    private var data = Array<Int>()
    
    init(array: Array<Int>) throws {
        guard array.count == 81 else { throw SudokuError.initDataError }
        data = array
    }
    
    func isRangeValid(row: Int, column: Int) -> Bool {
        return 0 <= row && row < 9 && 0 <= column && column < 9
    }
    
    subscript(row: Int, column: Int) -> Int {
        get {
            return data[row*9+column]
        }
        set {
            data[row*9+column] = newValue
        }
    }
    
    mutating func solve() throws {
        var emptyCells = Array<(Int, Int)>()
        for i in 0...8 {
            for j in 0...8 {
                if self[i, j] == 0 {
                    emptyCells.append((i, j))
                }
            }
        }
        
        var index = 0
        while index < emptyCells.count {
            let (a, b) = emptyCells[index]
            if self[a, b] < 9 {
                self[a, b]++
                if isSafe(a, y: b) {
                    index++
                }
            } else {
                self[a, b] = 0
                index--
            }
            if index < 0 { throw SudokuError.invalidSudoku }
        }
    }
    
    func isSafe(x: Int, y: Int) -> Bool {
        return isRowSafe(x, y: y) && isColumnSafe(x, y: y) && isCellSafe(x, y: y)
    }
    
    private func isRowSafe(x: Int, y: Int) -> Bool {
        for i in 0...8 {
            if i != y && self[x, y] == self[x, i] { return false }
        }
        return true
    }
    
    private func isColumnSafe(x: Int, y: Int) -> Bool {
        for i in 0...8 {
            if i != x && self[x, y] == self[i, y] { return false }
        }
        return true
    }
    
    private func isCellSafe(x: Int, y: Int) -> Bool {
        let a = x/3, b = y/3
        for i in 3*a...(3*a+2) {
            for j in 3*b...(3*b+2) {
                if i != x && j != y && self[x, y] == self[i, j] { return false }
            }
        }
        return true
    }
    
    var description: String {
        var output = ""
        for i in 0...8 {
            for j in 0...8 {
                output.appendContentsOf("\(self[i,j]) ")
                if j == 8 {output.appendContentsOf("\n")}
            }
        }
        return output
    }
}

do {
    let data = [0,9,0,4,2,0,0,7,0,
                0,4,0,0,0,7,0,0,2,
                0,0,7,0,0,0,1,0,6,
                7,0,0,0,0,2,0,0,0,
                0,0,0,6,0,5,0,0,0,
                0,0,0,3,0,0,0,0,4,
                4,0,1,0,0,0,5,0,0,
                9,0,0,2,0,0,0,1,0,
                0,6,0,0,3,9,0,2,0]
    var theSudoku = try Sudoku(array: data)
    try theSudoku.solve()
    print(theSudoku)
} catch SudokuError.initDataError {
    print("The count of init array isn't 81")
} catch SudokuError.invalidSudoku {
    print("This is not a valid sudoku")
}





