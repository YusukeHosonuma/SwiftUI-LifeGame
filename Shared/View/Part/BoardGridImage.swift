//
//  BoardGridImage.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/26.
//

import SwiftUI

#if os(macOS)
private typealias XImage = NSImage
#else
private typealias XImage = UIImage
#endif

struct BoardGridImage: View {
    let cellRenderSize: Int
    let boardSize: Int

    private let gridColor: CGColor = Color.gray.opacity(0.3).cgColor

    var body: some View {
        Image(image: renderImage())
            .resizable()
    }
    
    private func renderImage() -> XImage {
        let scale = cellRenderSize
        let size = CGSize(width: boardSize * scale + 1, height: boardSize * scale + 1)
        
        return GraphicsImageRenderer(size: size)
            .image { context in
                context.setFillColor(gridColor)

                // Draw grids
                for index in 0...boardSize + 1 {
                    let length = boardSize * scale + 1
                    context.fill(CGRect(x: scale * index, y: 0, width: 1, height: length)) // vertical lines
                    context.fill(CGRect(x: 0, y: scale * index, width: length, height: 1)) // horizontal lines
                }
            }
    }
}

struct BoardGridImage_Previews: PreviewProvider {
    static var previews: some View {
        BoardGridImage(cellRenderSize: 10, boardSize: 32)
            .previewLayout(.fixed(width: 320.0, height: 320))
    }
}
