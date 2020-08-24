//
//  ControlView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/02.
//

import SwiftUI

struct ControlView: View {
    @EnvironmentObject var historyRepository: FirestoreHistoryRepository
    @EnvironmentObject var gameManager: GameManager

    // Note:
    // 仕様かバグか判断がつかないので暫定対処（beta5）❗
    // https://qiita.com/usk2000/items/1f8038dedf633a31dd78
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var network: NetworkMonitor
    
    @EnvironmentObject var boardStore: BoardStore
    
    @State var isPresentedListSheet = false
    
    // MARK: View
    
    var body: some View {
        HStack {
            if gameManager.state == .play {
                stopButton()
            } else {
                playButton()
            }
            nextButton()

            Spacer()
            
            SheetButton(by: $isPresentedListSheet) {
                Image(systemName: "list.bullet")
            } content: {
                BoardSelectView(boardStore: boardStore, isPresented: $isPresentedListSheet)
                     .environmentObject(setting)
                     .environmentObject(authentication)
                     .environmentObject(network)
            }

            ActionMenu {
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .buttonStyle(ButtonStyleCircle())
    }
    
    private func playButton() -> some View {
        Button(action: gameManager.play) {
            Image(systemName: "play.fill")
        }
        .disabled(gameManager.state.canPlay)
    }
    
    private func stopButton() -> some View {
        Button(action: gameManager.stop) {
            Image(systemName: "stop.fill")
        }
        .buttonStyle(ButtonStyleCircle(color: .orange))
        .disabled(gameManager.state.canStop)
    }
    
    private func nextButton() -> some View {
        Button(action: gameManager.next) {
            Image(systemName: "arrow.right.to.line.alt")
        }
        .disabled(gameManager.state.canNext)
    }
}

//struct ControlView_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlView(viewModel: MainGameViewModel())
//            .previewLayout(.sizeThatFits)
//    }
//}
