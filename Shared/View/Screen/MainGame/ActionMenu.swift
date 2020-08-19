//
//  MenuView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/02.
//

import SwiftUI

struct ActionMenu<Label>: View where Label: View {
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
        
        Button(action: { isPresentedClearAlert.toggle() }) {
            HStack {
                Text("Clear")
                Image(systemName: "xmark.circle")
            }
        }
        .foregroundColor(.red) // TODO: not working in beta5❗
        .alert(isPresented: $isPresentedClearAlert, content: clearAlert)
        
        Divider()
        
        Button(action: { viewModel.tapRandomButton() }) {
            HStack {
                Text("Random")
                Image(systemName: "square.grid.2x2.fill")
            }
        }
    }
    
    // MARK: Actions
    
    private func clearAlert() -> Alert {
        Alert(
            title: Text("Do you want to clear?"),
            primaryButton: .cancel(),
            secondaryButton: .destructive(Text("Clear"), action: viewModel.tapClear))
    }
}
