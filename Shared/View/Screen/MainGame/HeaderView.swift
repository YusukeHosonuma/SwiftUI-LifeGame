//
//  HeaderView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/05.
//

import SwiftUI

struct HeaderView: View {
    let generation: Int
    let size: Int
    
    var body: some View {
        HStack {
            Text("Genration: \(generation)")
            Spacer()
            Text("\(size) x \(size)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            view(colorScheme: .light)
            view(colorScheme: .dark)
        }
    }
    
    @ViewBuilder
    static func view(colorScheme: ColorScheme) -> some View {
        HeaderView(generation: 123, size: 17)
            .preferredColorScheme(colorScheme)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
