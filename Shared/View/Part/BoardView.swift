//
//  BoardView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/07.
//

import SwiftUI
import LifeGame

struct BoardView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    var board: LifeGameBoard
    var cellWidth: CGFloat
    var cellPadding: CGFloat
    var lightModeCellColor: Color
    var darkModeCellColor: Color
    var tapCell: (Int, Int) -> ()

    // MARK: Computed properties
    
    var width: CGFloat {
        (cellWidth + (cellPadding * 2)) * CGFloat(board.size) + 6
    }

    // MARK: View

    var body: some View {
        // Rows
        VStack(spacing: 0) {
            ForEach(board.rows.withIndex(), id: \.0) { y, row in
                
                // Cols
                HStack(spacing: 0) {
                    ForEach(row.withIndex(), id: \.0) { x, cell in
                        CellView(color: cellBackgroundColor(cell: cell), size: cellWidth)
                            .padding(cellPadding)
                            .contentShape(Rectangle())
                            .onTapGesture(perform: {
                                tapCell(x, y)
                            })
                    }
                }
            }
        }
        .padding(3)
        .border(Color.gray, width: 2)
    }
        
    private func cellBackgroundColor(cell: Cell) -> Color {
        switch (cell, colorScheme) {
        case (.die, _):        return .clear
        case (.alive, .light): return lightModeCellColor
        case (.alive, .dark):  return darkModeCellColor
        @unknown default: fatalError()
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            view(colorScheme: .light)
            view(colorScheme: .dark)
        }
    }
    
    static func view(colorScheme: ColorScheme) -> some View {
        BoardView(
            board: BoardPreset.nebura.board,
            cellWidth: 20,
            cellPadding: 1,
            lightModeCellColor: .black,
            darkModeCellColor: .white,
            tapCell: { _, _ in }
        )
        .colorScheme(colorScheme) // これはすでに deprecated だが、ここでは適用しないと機能しない（beta4 in macOS Big Sur）
        .preferredColorScheme(colorScheme)
        .previewLayout(.sizeThatFits)
    }
}
