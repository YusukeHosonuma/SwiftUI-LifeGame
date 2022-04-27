//
//  ContentView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/07.
//

import SwiftUI
import LifeGame
import Core

struct ContentView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var boardManager: BoardManager
    @EnvironmentObject var authentication: Authentication
    
    // MARK: Views

    var body: some View {
        ZStack {
            contentView()
            
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
    
    @ViewBuilder
    private func contentView() -> some View {
        if authentication.isSignIn {
            VSplitView {
                boardView()
                PatternHistoryView()
                    .frame(height: 120)
                    .padding()
            }
            
        } else {
            boardView()
        }
    }

    private func boardView() -> some View {
        BoardContainerView()
            .padding(40)
            .aspectRatio(1.0, contentMode: .fit)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
