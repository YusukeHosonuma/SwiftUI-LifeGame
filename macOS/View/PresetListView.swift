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
        // TODO: Use Lazy
        List {
            Section(header: Text("Presets")) {
                ForEach(viewModel.items) { item in
                    HStack {
                        BoardThumnailView(board: LifeGameBoard(board: item.makeBoard()))
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
        let board = document.makeBoard()
        LifeGameContext.shared.setBoard(board) // TODO: refactor
    }
}

struct PresetListView_Previews: PreviewProvider {
    static var previews: some View {
        PresetListView()
    }
}
