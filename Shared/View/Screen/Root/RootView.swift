//
//  ContainerView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI

struct RootView: View {
    var viewModel: MainGameViewModel
    
    var body: some View {
        #if os(macOS)
        MainGameView(viewModel: viewModel)
        #else
        TabView {
            MainGameView()
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Game")
                }
            SettingView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        #endif
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: MainGameViewModel())
    }
}
