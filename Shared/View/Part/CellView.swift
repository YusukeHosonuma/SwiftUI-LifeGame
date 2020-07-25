//
//  CellView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI

struct CellView: View {
    var color: Color
    var size: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: size, height: size, alignment: .center)
            .border(Color.gray)
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(color: .yellow, size: 20)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
