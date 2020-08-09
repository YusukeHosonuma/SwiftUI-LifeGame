//
//  BoardListCell.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/06.
//

import SwiftUI
import LifeGame
import Foundation

struct BoardListCell: View {
    @Environment(\.colorScheme) var colorScheme
    
    var item: BoardDocument
    
    var body: some View {
        HStack() {
            Text("\(item.title)")
            Spacer()
            BoardThumnailImage(board: item.makeBoard().extended(by: .die))
                .frame(width: 60, height: 60, alignment: .center)
        }
    }
}

struct BoardListCell_Previews: PreviewProvider {

    static var previews: some View {
        view(title: "Nebura", board: BoardPreset.nebura.board, colorScheme: .light)
        view(title: "Nebura", board: BoardPreset.nebura.board, colorScheme: .dark)
        view(title: "SpaceShip", board: BoardPreset.spaceShip.board, colorScheme: .dark)
    }
    
    @ViewBuilder
    private static func view(title: String, board: LifeGameBoard, colorScheme: ColorScheme) -> some View {
        BoardListCell(
            item: BoardDocument(id: nil,
                                title: title,
                                size: board.size,
                                cells: board.cells.map(\.rawValue))
        )
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(colorScheme)
    }
}
