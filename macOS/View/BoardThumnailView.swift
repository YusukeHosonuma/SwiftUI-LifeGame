//
//  BoardThumnailView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/07.
//

import SwiftUI
import LifeGame

struct BoardThumnailView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    var board: LifeGameBoard
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(board.rows.withIndex(), id: \.0) { y, row in
                HStack(spacing: 0) {
                    ForEach(row.withIndex(), id: \.0) { x, cell in
                        CellView(color: cellColor(cell), size: 8) // TODO: 盤面サイズで全体の大きさが変わってしまうのでそのうち修正
                    }
                }
            }
        }
    }
    
    private func cellColor(_ cell: Cell) -> Color {
        switch (cell, colorScheme) {
        case (.die, _):        return .clear
        case (.alive, .light): return .black
        case (.alive, .dark):  return .white
        @unknown default: fatalError()
        }
    }
}

struct BoardThumnailView_Previews: PreviewProvider {
    static var previews: some View {
        BoardThumnailView(board: BoardPreset.nebura.board)
    }
}
