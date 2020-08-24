//
//  BoardManager.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/24.
//

import SwiftUI
import LifeGame
import Combine

// Important ✅
// このクラスのプロパティ`board`はアニメーション中に頻繁に更新されるため、本当に必要な箇所以外では`GameManager`を経由して処理すること。

final class BoardManager: ObservableObject {
    static let shared = BoardManager()

    @Published var board: LifeGameBoard = LifeGameBoard(size: 40)

    private let setting = SettingEnvironment.shared

    private var cancellables: [AnyCancellable] = []

    init() {
        setting.$boardSize
            .dropFirst()
            .sink { [weak self] size in
                guard let self = self else { return }
                self.board.changeBoardSize(to: size)
            }
            .store(in: &cancellables)
    }
    
    func setBoard(board: Board<Cell>) {
        let newSize = (board.size <= self.board.size)
            ? self.board.size
            : PresetBoardSizes.first(where: { board.size < $0 }) ?? board.size // fail-safe
        
        let newBoard = Board(size: newSize, cell: Cell.die).setBoard(toCenter: board)
        self.board = LifeGameBoard(board: newBoard)
    }
    
    func setLifeGameBoard(board: LifeGameBoard) {
        self.board = board
    }
    
    func next() {
        board.next()
    }
    
    func clear() {
        board.clear()
    }
    
    func generateRandom() {
        board = LifeGameBoard.random(size: board.size)
    }
    
    func tapCell(x: Int, y: Int) {
        board.toggle(x: x, y: y)
    }
}

