//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import XCTest
@testable import LifeGame

final class BoardTests: XCTestCase {
    func testExample() {
        
        let board = Board(cells: [
            0, 0, 0,
            0, 1, 0,
            0, 0, 0,
        ])
        
        XCTAssertEqual(board.cells.map(\.rawValue), [
            0, 0, 0,
            0, 1, 0,
            0, 0, 0,
        ])
        
        let next = board.next()
        XCTAssertEqual(next.cells.map(\.rawValue), [
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
        ])
    }
    
    func test() {
        // life = 0
        assertBoard([
            0, 0, 0,
            0, 1, 0,
            0, 0, 0,
        ], [
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
        ])

        // life = 1
        assertBoard([
            0, 1, 0,
            0, 1, 0,
            0, 0, 0,
        ], [
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
        ])

        // life = 2
        assertBoard([
            0, 1, 1,
            0, 1, 0,
            0, 0, 0,
        ], [
            0, 1, 1,
            0, 1, 1,
            0, 0, 0,
        ])
        
        // life = 3
        assertBoard([
            0, 1, 1,
            0, 1, 1,
            0, 0, 0,
        ], [
            0, 1, 1,
            0, 1, 1,
            0, 0, 0,
        ])
        
        // life = 4
        assertBoard([
            0, 1, 1,
            0, 1, 1,
            0, 0, 1,
        ], [
            0, 1, 1,
            0, 0, 0,
            0, 1, 1,
        ])
        
        // life = 5
        assertBoard([
            0, 1, 1,
            0, 1, 1,
            0, 1, 1,
        ], [
            0, 1, 1,
            1, 0, 0,
            0, 1, 1,
        ])
        
        // life = 6
        assertBoard([
            0, 1, 1,
            0, 1, 1,
            1, 1, 1,
        ], [
            0, 1, 1,
            0, 0, 0,
            1, 0, 1,
        ])

        // life = 7
        assertBoard([
            0, 1, 1,
            1, 1, 1,
            1, 1, 1,
        ], [
            1, 0, 1,
            0, 0, 0,
            1, 0, 1,
        ])
        
        // life = 8
        assertBoard([
            1, 1, 1,
            1, 1, 1,
            1, 1, 1,
        ], [
            1, 0, 1,
            0, 0, 0,
            1, 0, 1,
        ])
    }
    
    func assertBoard(_ before: [Int], _ after: [Int]) {
        let board = Board(cells: before)
        let actual = board.next().cells.map(\.rawValue)
        
        func format(_ cells: [Int]) -> String {
            cells.map { $0 == 1 ? "■" : "□" }.group(by: 3).map { $0.joined() }.joined(separator: "\n")
        }
        
        XCTAssertEqual(actual, after, "\n\n" + """
        input:
        \(format(before))

        expedted:
        \(format(after))

        actual:
        \(format(actual))
        """)
    }
}

final class ArrayExtensionTests: XCTestCase {
    func test() {
        XCTAssertEqual(Array(0..<6).group(by: 1), [[0], [1], [2], [3], [4], [5]])
        XCTAssertEqual(Array(0..<6).group(by: 2), [[0, 1], [2, 3], [4, 5]])
        XCTAssertEqual(Array(0..<6).group(by: 3), [[0, 1, 2], [3, 4, 5]])
        XCTAssertEqual(Array(0..<6).group(by: 6), [[0, 1, 2, 3, 4, 5]])
        XCTAssertEqual(Array(0..<6).group(by: 7), [[0, 1, 2, 3, 4, 5]])

        XCTAssertEqual(Array(0..<7).group(by: 3), [[0, 1, 2], [3, 4, 5], [6]])
        XCTAssertEqual(Array(0..<8).group(by: 3), [[0, 1, 2], [3, 4, 5], [6, 7]])
        XCTAssertEqual(Array(0..<9).group(by: 3), [[0, 1, 2], [3, 4, 5], [6, 7, 8]])
    }
}
