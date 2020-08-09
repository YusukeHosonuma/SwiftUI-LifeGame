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
    var style: BoardSelectStyle
    
    @Namespace private var nspace

    var body: some View {
        switch style {
        case .grid:
            VStack {
                BoardThumnailImage(board: item.makeBoard().extended(by: .die))
                    .matchedGeometryEffect(id: "thumbnail-\(item.title)", in: nspace)
                Text(item.title)
                    .font(.subheadline)
                    .fixedSize(horizontal: true, vertical: true)
                    .matchedGeometryEffect(id: "title-\(item.title)", in: nspace)
            }

        case .list:
            VStack(spacing: 0) {
                HStack() {
                    Text("\(item.title)")
                        .font(.subheadline)
                        .matchedGeometryEffect(id: "title-\(item.title)", in: nspace)
                        .fixedSize(horizontal: true, vertical: true)
                    Spacer()
                    BoardThumnailImage(board: item.makeBoard().extended(by: .die))
                        .frame(width: 60, height: 60, alignment: .center)
                        .matchedGeometryEffect(id: "thumbnail-\(item.title)", in: nspace)
                }.padding()
                Divider()
            }
        }
    }
}

struct BoardGridCell_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            gridView(title: "Nebura",    board: BoardPreset.nebura.board,    colorScheme: .light)
            gridView(title: "Nebura",    board: BoardPreset.nebura.board,    colorScheme: .dark)
            gridView(title: "SpaceShip", board: BoardPreset.spaceShip.board, colorScheme: .dark)
        }
        Group {
            listView(title: "Nebura",    board: BoardPreset.nebura.board,    colorScheme: .light)
            listView(title: "Nebura",    board: BoardPreset.nebura.board,    colorScheme: .dark)
            listView(title: "SpaceShip", board: BoardPreset.spaceShip.board, colorScheme: .dark)
        }
    }
    
    @ViewBuilder
    private static func gridView(title: String, board: LifeGameBoard, colorScheme: ColorScheme) -> some View {
        BoardGridCell(item: BoardDocument(title: title, board: board), style: .grid)
            .previewLayout(.fixed(width: 200.0, height: 200.0))
            .preferredColorScheme(colorScheme)
    }
    
    @ViewBuilder
    private static func listView(title: String, board: LifeGameBoard, colorScheme: ColorScheme) -> some View {
        BoardGridCell(item: BoardDocument(title: title, board: board), style: .list)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(colorScheme)
    }
}
