//
//  BoardListView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/06.
//

import SwiftUI
import LifeGame

private enum Style {
    case grid
    case list
    
    mutating func toggle() {
        switch self {
        case .grid:
            self = .list
            
        case .list:
            self = .grid
        }
    }
    
    var imageName: String {
        switch self {
        case .grid:
            return "list.bullet"

        case .list:
            return "square.grid.2x2.fill"
        }
    }
}

struct BoardSelectView: View {
    @Binding var isPresented: Bool
    var boardDocuments: [BoardDocument]
    
    @State private var style: Style = .grid

    // MARK: View
    
    var body: some View {
        NavigationView {
            Group {
                // TODO: 将来的にはトランジションでキレイに切り替えたい。
                switch style {
                case .grid:
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(boardDocuments, id: \.title) { item in
                                Button(action: { tapCell(board: item) }) {
                                    BoardGridCell(item: item)
                                }
                            }
                        }
                    }
                    
                case .list:
                    ScrollView {
                        LazyVStack {
                            ForEach(boardDocuments, id: \.title) { item in
                                Divider()
                                Button(action: { tapCell(board: item) }) {
                                    BoardListCell(item: item)
                                }
                                .padding([.horizontal])
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Select board", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel", action: tapCancel),
                                trailing: Button(action: tapChangeStyleButton) {
                                    Image(systemName: style.imageName)
                                })
        }
    }
    
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    // MARK: Actions
    
    private func tapChangeStyleButton() {
        style.toggle()
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
