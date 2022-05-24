//
//  BoardGridImage.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/26.
//

//import SwiftUI
//private let borderWidth: CGFloat = 1.0 // FIXME: `1.0`だと 128 x 128 で一部の線が描画されない
//
//struct BoardGridImage: View {
//    let cellRenderSize: Int
//    let boardSize: Int
//
//    private let gridColor: CGColor = Color.gray.opacity(0.3).toCGColor()
//
//    var body: some View {
//        let scale = cellRenderSize
//        let renderWidth = CGFloat(boardSize * scale + 1)
//        
//        Canvas { canvasContext, size in
//            canvasContext.scaleBy(x: size.width / renderWidth, y: size.height / renderWidth)
//            canvasContext.withCGContext { context in
//                context.setFillColor(gridColor)
//
//                // Draw grids
//                for index in 0...boardSize + 1 {
//                    let length = CGFloat(boardSize * scale) + borderWidth
//                    context.fill(CGRect(x: CGFloat(scale * index), y: 0, width: borderWidth, height: length)) // vertical lines
//                    context.fill(CGRect(x: 0, y: CGFloat(scale * index), width: length, height: borderWidth)) // horizontal lines
//                }
//                
//                context.makeImage()
//            }
//        }
//    }
//}
//
//struct BoardGridImage_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardGridImage(cellRenderSize: 10, boardSize: 32)
//            .previewLayout(.fixed(width: 320.0, height: 320))
//    }
//}
