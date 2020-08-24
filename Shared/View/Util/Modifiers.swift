//
//  Modifiers.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/18.
//

import SwiftUI

extension Text {
    func emptyContent() -> some View {
        self.foregroundColor(.secondary).padding()
    }
}

extension View {
    func enabled(_ condition: Bool) -> some View {
        self.disabled(!condition)
    }
}
