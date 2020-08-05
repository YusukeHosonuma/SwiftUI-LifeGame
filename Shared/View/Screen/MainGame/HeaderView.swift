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
        .padding([.horizontal])
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(generation: 123, size: 17)
            .previewLayout(.sizeThatFits)
    }
}
