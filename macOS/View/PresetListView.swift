//
//  PresetListView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/07.
//

import SwiftUI
import LifeGame

struct PresetListView: View {
    @StateObject var viewModel = FirestoreBoardRepository()
    
    var body: some View {
        List {
            Section(header: Text("Presets")) {
                ForEach(viewModel.items) { item in
                    HStack {
                        BoardThumnailView(board: item.makeBoardForRender())
                        Text("\(item.title)")
                    }
                    .contentShape(Rectangle()) // ❗not working in beta4
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
        // TODO: Firestoreのデータトリムが終わったら不要になる
        let board = Board(size: document.size, cells: document.cells.map { $0 == 0 ? Cell.die : Cell.alive })
            .trimed { $0 == .die }
        LifeGameContext.shared.setBoard(board)
    }
}

struct PresetListView_Previews: PreviewProvider {
    static var previews: some View {
        PresetListView()
    }
}
