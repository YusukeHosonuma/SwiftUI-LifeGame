//
//  PresetListView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/07.
//

import SwiftUI
import LifeGame

struct PresetListView: View {
    @EnvironmentObject var boardRepository: FirestoreBoardRepository
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        // TODO: Use Lazy
        List {
            Section(header: Text("Presets")) {
                ForEach(boardRepository.items) { item in
                    HStack {
                        BoardThumbnailImage(board: item.makeBoard(), cacheKey: item.id)
                            .frame(width: 120, height: 120, alignment: .center)
                        Text("\(item.title)")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        tapCell(board: item)
                    }
                    Divider()
                }
            }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 120, idealWidth: 200, maxHeight: .infinity)
    }
    
    private func tapCell(board document: BoardDocument) {
        let board = document.makeBoard()
        gameManager.setBoard(board: board)
    }
}

struct PresetListView_Previews: PreviewProvider {
    static var previews: some View {
        PresetListView()
    }
}
