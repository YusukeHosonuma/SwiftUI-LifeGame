//
//  SettingAboutView.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/18.
//

import SwiftUI

struct SettingAboutView: View {
    var body: some View {
        List {
            Section(header: Text("Author")) {
                Text("Yusuke Hosonuma")
                Link("Twitter (@tobi462)", destination: URL(string: "https://twitter.com/tobi462")!)
            }
            Section(
                header: Text("GitHub"),
                footer: Text("This app is Open Source Software.")) {
                Link("YusukeHosonuma / SwiftUI-LifeGame",
                     destination: URL(string: "https://github.com/YusukeHosonuma/SwiftUI-LifeGame")!)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("About")
    }
}

struct SettingAboutView_Previews: PreviewProvider {
    static var previews: some View {
        SettingAboutView()
    }
}
