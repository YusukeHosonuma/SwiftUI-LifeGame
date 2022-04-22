//
//  ScaleChangeButton.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/27.
//

import SwiftUI

private let scales: [Int] = [75, 100, 125]

struct ScaleChangeButton: View {
    @Binding var scale: CGFloat

    var body: some View {
        Menu {
            ForEach(scales, id: \.self) { value in
                Button("\(value)%") {
                    withAnimation {
                        scale = CGFloat(value) / 100
                    }
                }
            }
        } label: {
            Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                .font(.largeTitle)
        }
    }
}

struct ScaleChangeButton_Previews: PreviewProvider {
    static var previews: some View {
        ScaleChangeButton(scale: .constant(100))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
