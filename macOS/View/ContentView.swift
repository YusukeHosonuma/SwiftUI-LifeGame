//
//  ContentView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/07.
//

import SwiftUI
import LifeGame

struct ContentView: View {
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var boardStore: BoardStore

    @ObservedObject var viewModel: MainGameViewModel

    var zoomLevel: Int

    private var cellWidth: CGFloat {
        CGFloat(20 + (zoomLevel - 5) * 2)
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Note:
                // 現時点ではウィンドウが再フォーカスされるとViewのサイズが不正になる不具合あり（beta5）❗
                VStack {
                    BoardContainerView(viewModel: viewModel)
                        .padding(40)
                        .aspectRatio(1.0, contentMode: .fit)

                    if authentication.isSignIn {
                        HStack {
                            Text("History")
                                .foregroundColor(.secondary)
                                .padding(.leading)
                            Spacer()
                        }
                        BoardSelectHistoryView(
                            items: boardStore.histories,
                            toggleStar: toggleStar,
                            tapItem: tapHistoryCell
                        )
                        .frame(height: 120, alignment: .leading)
                    }
                }

                VStack {
                    HStack {
                        Text("Generation: \(viewModel.board.generation)")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            }
            PresetListView()
        }
    }
    
    // TODO: iOS版とほとんど同じ処理なので`BoardSelectHistoryView`に責務を移動したほうが良さそう。（そのうち）
    
    private func toggleStar(boardID: String) {
        self.boardStore.toggleLike(boardID: boardID)
    }
    
    private func tapHistoryCell(_ item: BoardHistoryItem) {
        selectBoard(boardDocumentID: item.boardDocumentID, board: item.board)
    }

    private func selectBoard(boardDocumentID: String, board: Board<Cell>) {
        if authentication.isSignIn {
            boardStore.addToHistory(boardID: boardDocumentID)
        }
        LifeGameContext.shared.setBoard(board)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
