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
    @EnvironmentObject var boardManager: BoardManager
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var boardStore: BoardStore

    var zoomLevel: Int

    private var cellWidth: CGFloat {
        CGFloat(20 + (zoomLevel - 5) * 2)
    }

    var body: some View {
        ZStack {
            // Note:
            // 履歴読み込み時に一部の表示が崩れる問題あり（Xcode beta 6 / macOS-beta 5）❗
            VStack {
                if authentication.isSignIn {
                    VSplitView {
                        boardView()
                        
                        BoardSelectHistoryView(
                            items: boardStore.histories,
                            toggleStar: toggleStar,
                            tapItem: tapHistoryCell
                        )
                        .padding(.top)
                        .frame(idealHeight: 120)
                    }
                } else {
                    boardView()
                }
            }
            
            VStack {
                HStack {
                    Text("Generation: \(boardManager.board.generation)")
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
    }

    private func boardView() -> some View {
        BoardContainerView()
            .padding(40)
            .aspectRatio(1.0, contentMode: .fit)
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
        boardManager.setBoard(board: board)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
