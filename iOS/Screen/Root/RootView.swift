//
//  ContainerView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel: MainGameViewModel
    
    var body: some View {
        TabView {
            MainGameView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "square.grid.3x3.fill.square")
                    Text("Play")
                }
            SettingRootView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: MainGameViewModel())
    }
}
