//
//  ControlView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/02.
//

import SwiftUI
import Combine

struct ControlView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var network: NetworkMonitor
    @EnvironmentObject var boardStore: BoardStore
    @EnvironmentObject var applicationRouter: ApplicationRouter
    @EnvironmentObject var patternStore: PatternStore

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
                
                SheetButton(by: $gameManager.isPresentedPatternSelectSheet) {
                    Image(systemName: "list.bullet")
                } content: {
                    PatternSelectSheetView(presented: $gameManager.isPresentedPatternSelectSheet)
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
        .onReceive(applicationRouter.$didOpenPatteenURL.compactMap { $0 }, perform: gameManager.setPattern)
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
