//
//  ControlView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/02.
//

import SwiftUI
import Combine

var cancellables: [AnyCancellable] = []

struct ControlView: View {
    @EnvironmentObject var gameManager: GameManager

    // Note:
    // 仕様かバグか判断がつかないので暫定対処（beta 6）❗
    // https://qiita.com/usk2000/items/1f8038dedf633a31dd78
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var network: NetworkMonitor
    @EnvironmentObject var boardStore: BoardStore
    @EnvironmentObject var applicationRouter: ApplicationRouter
    @EnvironmentObject var patternStore: PatternStore

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
                    PatternSelectSheetView(presented: $isPresentedListSheet)
                    //AllPatternView(presented: $isPresentedListSheet)
                        .environmentObject(gameManager)
                        .environmentObject(authentication)
                        .environmentObject(boardStore)
                        .environmentObject(patternStore)
//                    PatterndGridView(url: URL(string: "https://lifegame-dev.web.app/pattern/$rats.json")!)
//                    BoardSelectView(boardStore: boardStore, isPresented: $isPresentedListSheet)
//                        .environmentObject(setting)
//                        .environmentObject(authentication)
//                        .environmentObject(network)
//                        .environmentObject(boardStore)
                }

                ActionMenuButton {
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .buttonStyle(ButtonStyleCircle())
        }
        .onReceive(applicationRouter.$didOpenPatteenURL.compactMap { $0 },
                   perform: didOpenPatternURL)
    }
    
    private func didOpenPatternURL(url: URL) {
        // TODO: 専用オブジェクトが処理する形にしたほうがいい、のかもしれない。
        PatternService.shared.fetch(from: url)
            .compactMap { $0 }
            .sink { item in
                patternStore.recordHistory(patternID: item.patternID)
                gameManager.setBoard(board: item.board)
                isPresentedListSheet = false
            }
            .store(in: &cancellables)
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
