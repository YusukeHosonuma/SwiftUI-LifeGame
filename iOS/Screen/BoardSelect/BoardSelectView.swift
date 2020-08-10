//
//  BoardListView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/06.
//

import SwiftUI
import LifeGame

struct BoardSelectView: View {
    @EnvironmentObject var setting: SettingEnvironment
    
    @Binding var isPresented: Bool
    var boardDocuments: [BoardDocument]

    // MARK: View
    
    var body: some View {
        NavigationView {
            Group {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(boardDocuments, id: \.id!) { item in
                            Button(action: { tapCell(board: item) }) {
                                BoardSelectCell(item: item, style: setting.boardSelectDisplayStyle)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Select board", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel", action: tapCancel),
                                trailing: Button(action: tapChangeStyleButton) {
                                    Image(systemName: setting.boardSelectDisplayStyle.imageName)
                                })
        }
    }
    
    var columns: [GridItem] {
        switch setting.boardSelectDisplayStyle {
        case .grid:
            return [
                GridItem(.adaptive(minimum: 100))
            ]
        case .list:
            return [
                GridItem(spacing: 0)
            ]
        }
    }
    
    // MARK: Actions
    
    private func tapChangeStyleButton() {
        withAnimation {
            setting.boardSelectDisplayStyle.toggle()
        }
    }
    
    private func tapCancel() {
        isPresented = false
    }
    
    private func tapCell(board document: BoardDocument) {
        let board = document.makeBoard()
        LifeGameContext.shared.setBoard(board) // TODO: refactor
        isPresented = false
    }
}

struct BoardSelectView_Previews: PreviewProvider {
    static let boards = [
        BoardDocument(id: "1", title: "Nebura", board: BoardPreset.nebura.board),
        BoardDocument(id: "2", title: "Spaceship", board: BoardPreset.spaceShip.board),
    ]
    
    static var previews: some View {
        BoardSelectView(isPresented: .constant(true), boardDocuments: boards)

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
