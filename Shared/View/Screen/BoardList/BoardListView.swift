//
//  BoardListView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/06.
//

import SwiftUI
import LifeGame

struct BoardListView: View {
    @StateObject var viewModel = BoardListViewModel()
    @Binding var isPresented: Bool
    
    var body: some View {
        List {
            Section(header: Text("Presets")) {
                ForEach(viewModel.items) { item in
                    Button(action: { tapCell(board: item) }) {
                        BoardListCellView(item: item)
                    }
                }
            }
        }
    }
    
    private func tapCell(board document: BoardDocument) {
        let board = LifeGameBoard(size: document.size, cells: document.cells)
        LifeGameContext.shared.setBoard(board)
        isPresented = false
    }
}

struct BoardListView_Previews: PreviewProvider {
    static var previews: some View {
        BoardListView(isPresented: .constant(true))
    }
}
