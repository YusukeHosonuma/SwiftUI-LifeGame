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
    
    @StateObject var patternSelectManager: PatternSelectManager = .init()

    var body: some View {
        ZStack {
            VStack {
                if authentication.isSignIn {
                    VSplitView {
                        boardView()

                        PatternGridListView(
                            style: .horizontal,
                            patternURLs: patternSelectManager.historyURLs,
                            didTapItem: didTapItem,
                            didToggleStar: didToggleStar
                        )
                        .padding()
                        .frame(height: 120)
                    }
                    .enabled(false)
                    
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
        patternSelectManager.select(item: item)
    }
    
    private func didToggleStar(item: PatternItem) {
        patternSelectManager.toggleStar(item: item)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
