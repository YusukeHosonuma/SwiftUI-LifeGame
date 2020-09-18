//
//  ContentView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/07.
//

import SwiftUI
import LifeGame

struct ContentView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var boardManager: BoardManager
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var patternStore: PatternStore

    var body: some View {
        ZStack {
            // Note:
            // 履歴読み込み時に一部の表示が崩れる問題あり（Xcode beta 6 / macOS-beta 5）❗
            VStack {
                if authentication.isSignIn {
                    VSplitView {
                        boardView()
                        
                        PatternGridListView(
                            style: .horizontal,
                            patternURLs: patternStore.historyURLs,
                            didTapItem: didTapItem,
                            didToggleStar: didToggleStar
                        )
                        .padding()
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

    // MARK: Action
    
    private func didTapItem(item: PatternItem) {
        patternStore.recordHistory(patternID: item.patternID)
        gameManager.setBoard(board: item.board)
    }
    
    private func didToggleStar(item: PatternItem) {
        patternStore.toggleStar(item: item)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
