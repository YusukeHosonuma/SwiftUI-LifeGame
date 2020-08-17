//
//  BoardSelectContextMenu.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/17.
//

import SwiftUI

// TODO: Binding<Bool> を使うのがセオリーではあるが・・・
struct BoardSelectContextMenu: View {
    let isStared: Bool
    let toggleStar: () -> Void
    
    var body: some View {
        Button(action: toggleStar) {
            if isStared {
                Text("Unlike")
                Image(systemName: "star.slash")
            } else {
                Text("Like")
                Image(systemName: "star")
            }
        }
        // Note:
        // メニューのコンテンツ上での制限なのかアラートは表示できなかった。（beta4）❗
        // ```
        // @State var isPresentedAlert = false
        //
        // ...
        //
        // .alert(isPresented: $isPresentedAlert) {
        //     Alert(title: Text("Sign-in is needed."))
        // }
        // ```
    }
}

struct BoardSelectContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        Button("Please long-press") {}
            .contextMenu {
                BoardSelectContextMenu(isStared: true, toggleStar: {})
            }
    }
}
