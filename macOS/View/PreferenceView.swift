//
//  PreferenceView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI

private let CellSize: CGFloat = 20

struct PreferenceView: View {
    @EnvironmentObject private var setting: SettingEnvironment

    var body: some View {
        VStack {
            ColorPicker(selection: $setting.lightModeColor) {
                HStack {
                    CellView(color: setting.lightModeColor, size: CellSize)
                    Text("Light mode")
                }
            }
            // Note:
            // フレームサイズで制限しないとすごくでかく表示される。（macOS-beta 5）
            .frame(width: 240, height: 40)
            
            ColorPicker(selection: $setting.darkModeColor) {
                HStack {
                    CellView(color: setting.darkModeColor, size: CellSize)
                    Text("Dark mode")
                }
            }
            .frame(width: 240, height: 40)
        }
        .padding()
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
    }
}
