//
//  SettingView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI

private let CellSize: CGFloat = 20

struct SettingView: View {
    @EnvironmentObject private var setting: SettingEnvironment

    var body: some View {
        Form {
            Section(header: Text("Color")) {
                ColorPicker(selection: $setting.lightModeColor) {
                    HStack {
                        CellView(color: setting.lightModeColor, size: CellSize)
                        Text("Light mode")
                    }
                }
                ColorPicker(selection: $setting.darkModeColor) {
                    HStack {
                        CellView(color: setting.darkModeColor, size: CellSize)
                        Text("Dark mode")
                    }
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .preferredColorScheme(.light)
    }
}
