//
//  BoardSelectCell.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/09.
//

import SwiftUI
import LifeGame

struct BoardSelectCell: View {
    var item: BoardItem
    var style: BoardSelectStyle
    
    @Namespace private var nspace

    var body: some View {
        switch style {
        case .grid:
            VStack {
                // TODO: 実は`matchedGeometryEffect`って要らないのでは？
                BoardThumbnailImage(board: item.board, cacheKey: item.id)
                    .matchedGeometryEffect(id: "thumbnail-\(item.title)", in: nspace)

                HStack {
                    Text(item.title)
                        .lineLimit(1)
                        .foregroundColor(.accentColor)
                        .matchedGeometryEffect(id: "title-\(item.title)", in: nspace)
                    Spacer()
                    if item.stared {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
                .font(.system(.caption, design: .monospaced))
            }

        case .list:
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(item.title)")
                            .font(.system(.caption, design: .monospaced))
                            .matchedGeometryEffect(id: "title-\(item.title)", in: nspace)
                            .fixedSize(horizontal: true, vertical: true)
                            .foregroundColor(.accentColor)
                        Spacer()
                        Group {
                            if item.stared {
                                Image(systemName: "star.fill")
                            } else {
                                Image(systemName: "star")
                            }
                        }
                        .font(.footnote)
                        .foregroundColor(.yellow)
                    }
                    Spacer()
                    BoardThumbnailImage(board: item.board, cacheKey: item.id)
                        .frame(width: 60, height: 60, alignment: .center)
                        .matchedGeometryEffect(id: "thumbnail-\(item.title)", in: nspace)
                }.padding()
                Divider()
            }
        }
    }
}

// TODO:

//struct BoardGridCell_Previews: PreviewProvider {
//
//    static var previews: some View {
//        Group {
//            gridView(title: "Nebura",    board: BoardPreset.nebura.board,    colorScheme: .light)
//            gridView(title: "Nebura",    board: BoardPreset.nebura.board,    colorScheme: .dark)
//            gridView(title: "SpaceShip", board: BoardPreset.spaceShip.board, colorScheme: .dark)
//        }
//        Group {
//            listView(title: "Nebura",    board: BoardPreset.nebura.board,    colorScheme: .light)
//            listView(title: "Nebura",    board: BoardPreset.nebura.board,    colorScheme: .dark)
//            listView(title: "SpaceShip", board: BoardPreset.spaceShip.board, colorScheme: .dark)
//        }
//    }
//
//    @ViewBuilder
//    private static func gridView(title: String, board: LifeGameBoard, colorScheme: ColorScheme) -> some View {
//        BoardSelectCell(item: BoardDocument(title: title, board: board), style: .grid)
//            .previewLayout(.fixed(width: 200.0, height: 200.0))
//            .preferredColorScheme(colorScheme)
//    }
//
//    @ViewBuilder
//    private static func listView(title: String, board: LifeGameBoard, colorScheme: ColorScheme) -> some View {
//        BoardSelectCell(item: BoardDocument(title: title, board: board), style: .list)
//            .previewLayout(.sizeThatFits)
//            .preferredColorScheme(colorScheme)
//    }
//}
