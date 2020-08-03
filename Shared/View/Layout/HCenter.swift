//
//  HCenter.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/26.
//

import SwiftUI

struct HCenter<Content>: View where Content: View {
    var content: () -> Content
    
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            content()
            Spacer()
        }
    }
}

struct HCenter_LibraryContent: LibraryContentProvider {

    @LibraryContentBuilder
    var views: [LibraryItem] {
        LibraryItem(
            HCenter {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Content")/*@END_MENU_TOKEN@*/
            },
            title: "Horizontal Center",
            category: .layout
        )
    }
}
