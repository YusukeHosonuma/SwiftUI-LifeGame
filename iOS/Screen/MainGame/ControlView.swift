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
    // 仕様かバグか判断がつかないので暫定対処（beta 6）❗
    
    // https://qiita.com/usk2000/items/1f8038dedf633a31dd78
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var network: NetworkMonitor
    
    @EnvironmentObject var boardStore: BoardStore
    
    @State var isPresentedListSheet = false
    
    // MARK: View
    
    var body: some View {
        VStack(spacing: 16) {
            // Speed / Scale
            HStack {
                SpeedControlView(speed: $gameManager.speed, onEditingChanged: gameManager.speedChanged)
                    .padding(.trailing, 40)
                
                ScaleChangeButton(scale: $gameManager.scale)
            }
            
            // Play/Stop, Next, Menus
            HStack {
                if gameManager.state == .stop {
                    playButton()
                } else {
                    stopButton()
                }
                nextButton()

                Spacer()
                
                SheetButton(by: $isPresentedListSheet) {
                    Image(systemName: "list.bullet")
                } content: {
                    BoardSelectView(boardStore: boardStore, isPresented: $isPresentedListSheet)
                        // 今回もとりあえず再現するか待つ。（beta 6）✅
                        // .environmentObject(setting)
                        // .environmentObject(authentication)
                        // .environmentObject(network)
                }

                ActionMenuButton {
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .buttonStyle(ButtonStyleCircle())
        }
    }
    
    private func playButton() -> some View {
        Button(action: gameManager.play) {
            Image(systemName: "play.fill")
        }
        .enabled(gameManager.state.canPlay)
    }
    
    private func stopButton() -> some View {
        Button(action: gameManager.stop) {
            Image(systemName: "stop.fill")
        }
        .buttonStyle(ButtonStyleCircle(color: .orange))
        .enabled(gameManager.state.canStop)
    }
    
    private func nextButton() -> some View {
        Button(action: gameManager.next) {
            Image(systemName: "arrow.right.to.line.alt")
        }
        .enabled(gameManager.state.canNext)
    }
}

//struct ControlView_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlView(viewModel: MainGameViewModel())
//            .previewLayout(.sizeThatFits)
//    }
//}
