//
//  MenuView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/02.
//

import SwiftUI

struct ActionMenuButton<Content>: View where Content: View {
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var gameManager: GameManager
        
    let label: () -> Content
    
    // MARK: Private
    
    @State private var isPresentedClearAlert = false
    
    init(@ViewBuilder label: @escaping () -> Content) {
        self.label = label
    }

    // MARK: View
    
    var body: some View {
        Menu(content: content, label: label)
    }
    
    @ViewBuilder
    private func content() -> some View {

        // Note: ✅
        // 表示順はメニューの起点からとなる。（表示方向が上か下かで順番は変わる）
        
        Button(action: gameManager.clear) {
            HStack {
                Text("Clear")
                Image(systemName: "xmark.circle")
            }
        }
        .foregroundColor(.red) // Note: not working in beta 6❗
        
        Divider()
        
        Button(action: gameManager.generateRandom) {
            HStack {
                Text("Random")
                Image(systemName: "square.grid.2x2.fill")
            }
        }

        Divider()

        BoardSizePicker(selection: $setting.boardSize)
    }
}
