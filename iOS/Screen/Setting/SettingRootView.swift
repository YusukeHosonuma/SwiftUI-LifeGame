//
//  SettingRootView.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/18.
//

import SwiftUI

struct SettingRootView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: SettingAboutView()) {
                        Label("About", systemImage: "info.circle")
                    }
                }
                Section {
                    NavigationLink(destination: SettingLoginView()) {
                        Label("Login", systemImage: "person.crop.circle")
                    }
                    NavigationLink(destination: SettingConfigView()) {
                        Label("Game Config", systemImage: "gearshape")
                    }
                }
            }
            .listStyle(GroupedListStyle()) // Note: 明示的に指定しないと iPad でサイドバー表示になってしまう
            .navigationBarTitle("Settings")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
struct SettingRootView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRootView()
            .environmentObject(Authentication(mockSignIn: false))
            .colorScheme(.dark)
            .preferredColorScheme(.dark)

        SettingRootView()
            .environmentObject(Authentication(mockSignIn: false))
            .colorScheme(.light)
            .preferredColorScheme(.light)
    }
}
