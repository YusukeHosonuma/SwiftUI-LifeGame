//
//  ContainerView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        #if os(macOS)
        ContentView()
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

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
