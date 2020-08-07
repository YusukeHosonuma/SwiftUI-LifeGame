//
//  BoardListView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/06.
//

import SwiftUI
import LifeGame

struct BoardListView: View {
    @Binding var isPresented: Bool
    var boardDocuments: [BoardDocument]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Presets")) {
                    ForEach(boardDocuments, id: \.title) { item in
                        Button(action: { tapCell(board: item) }) {
                            BoardListCellView(item: item)
                        }
                    }
                }
            }
            .navigationBarTitle("Select board", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel", action: tapCancel))
        }
    }
    
    private func tapCancel() {
        isPresented = false
    }
    
    private func tapCell(board document: BoardDocument) {
        let board = LifeGameBoard(size: document.size, cells: document.cells)
        LifeGameContext.shared.setBoard(board) // TODO: refactor
        isPresented = false
    }
}

struct BoardListView_Previews: PreviewProvider {
    static let boards = [
        BoardDocument(id: "1", title: "Nebura", board: BoardPreset.nebura.board),
        BoardDocument(id: "2", title: "Spaceship", board: BoardPreset.spaceShip.board),
    ]
    
    static var previews: some View {
        BoardListView(isPresented: .constant(true), boardDocuments: boards)

        // Note:
        // Sheet style is not working in normal-preview (when live-preview is working) in beta4❗
        //
        // ```
        // EmptyView()
        //     .sheet(isPresented: .constant(true)) {
        //         BoardListView(isPresented: .constant(true), boardDocuments: boards)
        //     }
        // ```
    }
}
