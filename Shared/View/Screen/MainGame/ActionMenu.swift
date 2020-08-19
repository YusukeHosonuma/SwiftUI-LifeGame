//
//  MenuView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/02.
//

import SwiftUI

private let PresetSizes = [16, 32, 64, 96, 128]

struct ActionMenu<Label>: View where Label: View {
    @EnvironmentObject var setting: SettingEnvironment
    
    @ObservedObject var viewModel: MainGameViewModel
    
    let label: () -> Label
    
    // MARK: Private
    
    @State private var isPresentedClearAlert = false
    
    init(viewModel: MainGameViewModel, @ViewBuilder label: @escaping () -> Label) {
        self.viewModel = viewModel
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
        
        Button(action: viewModel.tapClear) {
            HStack {
                Text("Clear")
                Image(systemName: "xmark.circle")
            }
        }
        .foregroundColor(.red) // TODO: not working in beta5❗
        
        Divider()
        
        Button(action: viewModel.tapRandomButton) {
            HStack {
                Text("Random")
                Image(systemName: "square.grid.2x2.fill")
            }
        }

        Divider()
        
        Picker("", selection: $setting.boardSize) {
            ForEach(PresetSizes, id: \.self) { size in
                Button(action: { setting.boardSize = size }) {
                    HStack {
                        Text("\(size) x \(size)")
                        Image(systemName: "square.grid.2x2")
                    }
                }
            }
        }
    }
}
