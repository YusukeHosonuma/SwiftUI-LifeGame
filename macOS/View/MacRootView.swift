//
//  MacRootView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/07.
//

import SwiftUI

extension MacRootView {
    private enum SheetType: Int, Identifiable {
        case boardSelect
        case feedback
        
        var id: Int { rawValue }
    }
}

struct MacRootView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var fileManager: LifeGameFileManager
    @EnvironmentObject var authentication: Authentication

    private var title: String {
        fileManager.latestURL?.lastPathComponent ?? "Untitled"
    }
    
    @State private var presentedSheet: SheetType?
    
    @State var isPresentedSheet = false
    @State var isPresentedFeedbackSheet = false
    

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                MacNavigationView()
                ContentView(zoomLevel: setting.zoomLevel)
                    .sheet(item: $presentedSheet) {
                        switch $0 {
                        case .boardSelect:
                            // Note:
                            // とりあえずウィンドウサイズよりちょっと小さめで表示してみる。
                            BoardListView(dismiss: dismissSheet)
                                .frame(idealWidth: geometry.size.width * 0.8,
                                       idealHeight: geometry.size.height * 0.8)
                            
                        case .feedback:
                            if let uid = authentication.user?.uid {
                                MacFeedbackView(dismiss: dismissSheet, userID: uid)
                            }
                        }
                    }
            }
            .navigationTitle(title)
            .toolbar {
                Group {
                    ToolbarItem(placement: .navigation) {
                        IconButton(systemName: "sidebar.left", action: AppKitWrapper.toggleSidebar)
                            .keyboardShortcut("b", modifiers: .command)
                    }
                    
                    ToolbarItem(placement: .navigation) {
                        IconButton(systemName: "square.grid.2x2.fill") {
                            presentedSheet = .boardSelect
                        }
                    }
                }
                
                Group {
                    ToolbarItem(placement: .status) {
                        IconButton(systemName: "play.fill", action: gameManager.play)
                            .enabled(gameManager.state.canPlay)
                    }
                    
                    ToolbarItem(placement: .status) {
                        IconButton(systemName: "stop.fill", action: gameManager.stop)
                            .enabled(gameManager.state.canStop)
                    }
                    
                    ToolbarItem(placement: .status) {
                        IconButton(systemName: "arrow.right.to.line.alt", action: gameManager.next)
                            .enabled(gameManager.state.canNext)
                    }
                    
                    ToolbarItem(placement: .status) {
                        IconButton(systemName: "trash", action: gameManager.clear)
                    }

                    ToolbarItem(placement: .status) {
                        ScaleChangeButton(scale: $gameManager.scale)
                    }

                    ToolbarItem(placement: .status) {
                        BoardSizePicker(selection: $setting.boardSize)
                    }

                    ToolbarItem(placement: .status) {
                        IconButton(systemName: "exclamationmark.bubble") {
                            presentedSheet = .feedback
                        }
                    }
                }
            }
        }
    }
    
    private func dismissSheet() {
        presentedSheet = nil
    }
}

//struct MacRootView_Previews: PreviewProvider {
//    static var previews: some View {
//        MacRootView()
//    }
//}
