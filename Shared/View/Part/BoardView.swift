//
//  BoardView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/07.
//

import SwiftUI
import LifeGame

struct BoardView: View {
    @ObservedObject var viewModel: MainGameViewModel
    
    var cellWidth: CGFloat
    var cellPadding: CGFloat

    // MARK: Computed properties
    
    var width: CGFloat {
        (cellWidth + (cellPadding * 2)) * CGFloat(viewModel.board.size) + 6
    }

    // MARK: Private

    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @EnvironmentObject private var setting: SettingEnvironment

    // MARK: View

    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.board.rows.withIndex(), id: \.0) { y, row in
                HStack(spacing: 0) {
                    ForEach(row.withIndex(), id: \.0) { x, cell in
                        cellButton(x: x, y: y, cell: cell)
                    }
                }
            }
        }
        .padding(3)
        .border(Color.gray, width: 2)
    }
    
    private func cellButton(x: Int, y: Int, cell: Cell) -> some View {
        CellView(color: cellBackgroundColor(cell: cell), size: cellWidth)
            .padding(cellPadding)
            .contentShape(Rectangle())
            .onTapGesture(perform: {
                viewModel.tapCell(x: x, y: y)
            })
    }
    
    private func cellBackgroundColor(cell: Cell) -> Color {
        switch (cell, colorScheme) {
        case (.die, _):        return .clear
        case (.alive, .light): return setting.lightModeColor
        case (.alive, .dark):  return setting.darkModeColor
        @unknown default: fatalError()
        }
    }
}

//struct BoardView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardView()
//    }
//}
