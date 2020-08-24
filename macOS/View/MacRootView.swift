//
//  MacRootView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/07.
//

import SwiftUI

struct MacRootView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var fileManager: LifeGameFileManager

    private var title: String {
        fileManager.latestURL?.lastPathComponent ?? "Untitled"
    }
    
    @State var isPresentedSheet = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                MacNavigationView()
                ContentView(zoomLevel: setting.zoomLevel)
                    .sheet(isPresented: $isPresentedSheet) {
                        // Note:
                        // とりあえずウィンドウサイズよりちょっと小さめで表示してみる。
                        BoardListView(isPresented: $isPresentedSheet)
                            .frame(idealWidth: geometry.size.width * 0.8,
                                   idealHeight: geometry.size.height * 0.8)
                    }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    BoardSizeMenu(size: $setting.boardSize)
                }

                ToolbarItem(placement: .navigation) {
                    IconButton(systemName: "square.grid.2x2.fill") {
                        isPresentedSheet.toggle()
                    }
                }
                
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
                
                // TODO: Macアプリによくある拡大率をプルダウンから選ぶUIに変更したい。
                
                ToolbarItem(placement: .status) {
                    Button(action: {
                        if setting.zoomLevel < 10 {
                            setting.zoomLevel += 1
                        }
                    }) {
                        Image(systemName: "plus.magnifyingglass")
                    }
                }
                
                ToolbarItem(placement: .status) {
                    Button(action: {
                        if 0 < setting.zoomLevel {
                            setting.zoomLevel -= 1
                        }
                    }) {
                        Image(systemName: "minus.magnifyingglass")
                    }
                }
            }
        }
    }
}

//struct MacRootView_Previews: PreviewProvider {
//    static var previews: some View {
//        MacRootView()
//    }
//}
