//
//  BoardSizePicker.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/28.
//

import SwiftUI

let PresetSizes = [16, 32, 64, 96, 128]

struct BoardSizePicker: View {
    @Binding var selection: Int
    
    var body: some View {
        Picker("", selection: $selection) {
            
            // Note:
            // `DisclosureGroup`は表示されるもののタップしても展開されない。`Picker`の外側に配置するとレイアウト崩れ（beta 6）❗
            // ```
            // DisclosureGroup("Size") { ... }
            // ```
            
            ForEach(PresetSizes, id: \.self) { size in
                Label("\(size) x \(size)", systemImage: "square.grid.2x2")
            }
        }
    }
}

struct BoardSizePicker_Previews: PreviewProvider {
    static var previews: some View {
        BoardSizePicker(selection: .constant(32))
    }
}
