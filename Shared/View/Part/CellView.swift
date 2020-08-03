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
            .border(Color.gray.opacity(0.5))
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(color: .yellow, size: 20)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

struct CellView_LibraryContent: LibraryContentProvider {

    @LibraryContentBuilder
    var views: [LibraryItem] {
        LibraryItem(
            CellView(color: .black, size: 20),
            category: .control
        )
    }
}
