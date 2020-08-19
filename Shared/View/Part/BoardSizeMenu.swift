//
//  SwiftUIView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/05.
//

import SwiftUI

// TODO: mac側も`ActionMenu.swift`のバージョンに切り替えて、このクラスは（たぶん）削除する

let PresetBoardSizes: [Int] = [15, 25, 40, 60]

struct BoardSizeMenu: View {
    @Binding var size: Int
    
    @State private var isPresentedAlert = Array(repeating: false, count: PresetBoardSizes.count)
    
    var body: some View {
        Menu(content: {
            ForEach(PresetBoardSizes.withIndex(), id: \.0) { index, size in
                Button("\(size) x \(size)") {
                    isPresentedAlert[index].toggle()
                }
                .alert(isPresented: $isPresentedAlert[index], content: changeSizeAlert(size: size))
            }
        }, label: {
            #if os(macOS)
            // Note❗
            // Crash when use `Button`. (macOS-beta4)
            Text("\(size) x \(size)")
            #else
            Button("\(size) x \(size)") {}
            #endif
        })
    }

    private func changeSizeAlert(size: Int) -> () -> Alert {{
        Alert(
            title: Text("The board will be initialized..."),
            primaryButton: .cancel(),
            secondaryButton: .destructive(Text("Change")) {
                self.size = size
            })
    }}
}

struct BoardSizeMenuView_Previews: PreviewProvider {
    static var previews: some View {
        BoardSizeMenu(size: .constant(17))
            .previewLayout(.sizeThatFits)
    }
}
