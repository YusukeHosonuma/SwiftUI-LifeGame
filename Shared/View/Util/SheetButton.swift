//
//  SheetButton.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/19.
//

import SwiftUI

struct SheetButton<Label: View, Content: View>: View {
    private var label: () -> Label
    private var content: () -> Content
    @Binding private var isPresented: Bool

    init(by isPresented: Binding<Bool>,
         @ViewBuilder label: @escaping () -> Label,
         @ViewBuilder content: @escaping () -> Content
    ) {
        self.label = label
        self.content = content
        _isPresented = isPresented
    }
    
    var body: some View {
        Button(action: { isPresented.toggle() }, label: label)
            .sheet(isPresented: $isPresented, content: content)
    }
}

extension SheetButton where Label == Text {
    init(_ label: String,
         by isPresented: Binding<Bool>,
         @ViewBuilder content: @escaping () -> Content
    ) {
        self = SheetButton.init(by: isPresented, label: { Text(label) }, content: content)
    }
}
