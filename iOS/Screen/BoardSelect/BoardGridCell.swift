//
//  BoardGridCell.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/09.
//

import SwiftUI
import LifeGame

struct BoardGridCell: View {
    var item: BoardDocument
    
    var body: some View {
        VStack {
            BoardThumnailImage(board: item.makeBoard().extended(by: .die))
            Text(item.title)
                .font(.subheadline)
        }
    }
}

struct BoardGridCell_Previews: PreviewProvider {
    
    static var previews: some View {
        view(title: "Nebura", board: BoardPreset.nebura.board, colorScheme: .light)
        view(title: "Nebura", board: BoardPreset.nebura.board, colorScheme: .dark)
        view(title: "SpaceShip", board: BoardPreset.spaceShip.board, colorScheme: .dark)
    }
    
    @ViewBuilder
    private static func view(title: String, board: LifeGameBoard, colorScheme: ColorScheme) -> some View {
        BoardGridCell(
            item: BoardDocument(id: nil,
                                title: title,
                                size: board.size,
                                cells: board.cells.map(\.rawValue))
        )
        .previewLayout(.fixed(width: 200.0, height: 200.0))
        .preferredColorScheme(colorScheme)
    }
}
