//
//  SettingView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var setting: SettingEnvironment

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Colors")) {
                    ColorPicker("Light mode", selection: $setting.lightModeColor)
                    ColorPicker("Dark mode", selection: $setting.darkModeColor)
                }
            }.navigationBarTitle("Settings")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
