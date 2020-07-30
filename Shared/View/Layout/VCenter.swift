//
//  VCenter.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/30.
//

import SwiftUI

struct VCenter<Content>: View where Content: View {
    var content: () -> Content
    
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack {
            Spacer()
            content()
            Spacer()
        }
    }
}

struct VCenter_LibraryContent: LibraryContentProvider {

    @LibraryContentBuilder
    var views: [LibraryItem] {
        LibraryItem(
            VCenter {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Content")/*@END_MENU_TOKEN@*/
            },
            title: "Vertical Center",
            category: .layout
        )
    }
}
