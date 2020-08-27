//
//  BoardSelectContextMenu.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/17.
//

import SwiftUI

struct BoardSelectContextMenu: View {
    
    // MARK: Inputs

    @Binding var isStared: Bool
    
    // MARK: View
    
    var body: some View {
        Button(action: { isStared.toggle() }) {
            if isStared {
                Text("Unlike")
                Image(systemName: "star.slash")
            } else {
                Text("Like")
                Image(systemName: "star")
            }
        }
    }
}

struct BoardSelectContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        Button("Please long-press") {}
            .contextMenu {
                BoardSelectContextMenu(isStared: .init(get: { true }, set: { _ in }))
            }
    }
}
