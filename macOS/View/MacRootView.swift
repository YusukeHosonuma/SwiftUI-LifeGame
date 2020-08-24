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
    
    var body: some View {
        NavigationView {
            MacNavigationView()
            ContentView(zoomLevel: setting.zoomLevel)
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                BoardSizeMenu(size: $setting.boardSize)
            }

            ToolbarItem(placement: .status) {
                Button(action: gameManager.play) {
                    Image(systemName: "play.fill")
                }
                .enabled(gameManager.state.canPlay)
            }
            
            ToolbarItem(placement: .status) {
                Button(action: gameManager.stop) {
                    Image(systemName: "stop.fill")
                }
                .enabled(gameManager.state.canStop)
            }
            
            ToolbarItem(placement: .status) {
                Button(action: gameManager.next) {
                    Image(systemName: "arrow.right.to.line.alt")
                }
                .enabled(gameManager.state.canNext)
            }
            
            ToolbarItem(placement: .status) {
                Button(action: gameManager.clear) {
                    Image(systemName: "trash")
                }
            }
            
            // TODO: refactor
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

//struct MacRootView_Previews: PreviewProvider {
//    static var previews: some View {
//        MacRootView()
//    }
//}
