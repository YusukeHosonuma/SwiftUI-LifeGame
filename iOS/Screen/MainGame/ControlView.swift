//
//  ControlView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/02.
//

import SwiftUI
import Combine
import Core

// TODO: 🔍 View で cancellables を必要とされること自体、良くない兆候なのかもしれない。（コード的に問題はないが）
private var cancellables: [AnyCancellable] = []

struct ControlView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var network: NetworkMonitor
    @EnvironmentObject var applicationRouter: ApplicationRouter

    @State var presentedSheetSelect = false
    
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
                
                SheetButton(by: $presentedSheetSelect) {
                    Image(systemName: "list.bullet")
                } content: {
                    PatternSelectSheetView(presented: $presentedSheetSelect)
                        .environmentObject(gameManager)
                        .environmentObject(authentication)
                }

                ActionMenuButton {
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .buttonStyle(ButtonStyleCircle())
        }
        .onReceive(applicationRouter.$didOpenPatteenURL.compactMap { $0 }, perform: didOpenPatternURL)
    }
    
    private func didOpenPatternURL(url: URL) {
        gameManager.setPattern(from: url)
            .sink {
                self.presentedSheetSelect = false
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
