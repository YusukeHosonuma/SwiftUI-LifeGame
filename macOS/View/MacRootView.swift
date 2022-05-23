//
//  MacRootView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/07.
//

import SwiftUI
import Core
import Combine
import SwiftUICommon

extension MacRootView {
    private enum SheetType: Int, Identifiable {
        case boardSelect
        case feedback
        
        var id: Int { rawValue }
    }
}

// FIXME: 暫定対処（現状では開放されることがないので ObservableObject などに移す）
private var cancellables: Set<AnyCancellable> = []

struct MacRootView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var fileManager: LifeGameFileManager
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var applicationRouter: ApplicationRouter

    @State private var presentedSheet: SheetType?

    private var title: String {
        fileManager.latestURL?.lastPathComponent ?? "Untitled"
    }

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                MacSidebar()
                ContentView()
                    .sheet(item: $presentedSheet) {
                        switch $0 {
                        case .boardSelect:
                            // Note:
                            // とりあえずウィンドウサイズよりちょっと小さめで表示してみる。
                            PatternSelectWindow(dismiss: dismissSheet)
                                .frame(idealWidth: geometry.size.width * 0.8,
                                       idealHeight: geometry.size.height * 0.8)
                            
                        case .feedback:
                            if let uid = authentication.user?.uid {
                                FeedbackWindow(dismiss: dismissSheet, userID: uid)
                            }
                        }
                    }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    IconButton(
                        systemName: "sidebar.left",
                        action: AppKitWrapper.toggleSidebar
                    )
                    .keyboardShortcut("b", modifiers: .command)

                    IconButton(
                        systemName: "list.bullet",
                        action: { presentedSheet = .boardSelect }
                    )
                }
                
                ToolbarItemGroup(placement: .status) {
                    IconButton(
                        systemName: "play.fill",
                        action: gameManager.play
                    )
                    .enabled(gameManager.state.canPlay)
                    
                    IconButton(
                        systemName: "stop.fill",
                        action: gameManager.stop
                    )
                    .enabled(gameManager.state.canStop)
                    
                    IconButton(
                        systemName: "arrow.right.to.line.alt",
                        action: gameManager.next
                    )
                    .enabled(gameManager.state.canNext)
                    
                    IconButton(
                        systemName: "square.grid.2x2.fill",
                        action: gameManager.generateRandom
                    )
                    
                    IconButton(
                        systemName: "trash",
                        action: gameManager.clear
                    )
                    
                    ScaleChangeButton(scale: $gameManager.scale)
                    
                    BoardSizePicker(selection: $setting.boardSize)
                    
                    IconButton(
                        systemName: "exclamationmark.bubble",
                        action: { presentedSheet = .feedback }
                    )
                    .enabled(authentication.isSignIn)
                }
            }
        }
        .onReceive(applicationRouter.$didOpenPatteenURL.compactMap { $0 }, perform: didOpenPatternURL)
    }
    
    private func dismissSheet() {
        presentedSheet = nil
    }
    
    private func didOpenPatternURL(url: URL) {
        gameManager.setPattern(from: url)
            .sink {
                presentedSheet = nil
            }
            .store(in: &cancellables)
    }
}

//struct MacRootView_Previews: PreviewProvider {
//    static var previews: some View {
//        MacRootView()
//    }
//}
