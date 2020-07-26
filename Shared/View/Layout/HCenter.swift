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
        HStack {
            Spacer()
            content()
            Spacer()
        }
    }
}
