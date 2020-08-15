//
//  BoardRenderImage.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/14.
//

import SwiftUI
import LifeGame

#if os(macOS)
private typealias XImage = NSImage
#else
private typealias XImage = UIImage
#endif

struct BoardRenderImage: View {    
    let board: Board<Cell>
    let cellRenderSize: Int
    let cellColor: Color

    var body: some View {
        Image(image: renderImage())
            .resizable()
    }
    
    private var fillColor: CGColor {
        cellColor.cgColor
    }
    
    private var gridColor: CGColor {
        Color.gray.opacity(0.5).cgColor
    }

    private func renderImage() -> XImage {
        let scale = cellRenderSize
        let size = CGSize(width: board.size * scale + 1, height: board.size * scale + 1)
        
        return GraphicsImageRenderer(size: size)
            .image(actions: { context in
                context.setFillColor(fillColor)
                
                // Draw cells
                for (index, cell) in board.cells.enumerated() {
                    let x = (index % board.size) * scale
                    let y = (index / board.size) * scale
                    if cell == .alive {
                        context.fill(CGRect(origin: CGPoint(x: x + 1, y: y + 1), size: CGSize(width: scale - 1, height: scale - 1)))
                    }
                }
                
                // Draw grids
                context.setFillColor(gridColor)
                for index in 0...board.size + 1 {
                    let length = board.size * scale + 1
                    context.fill(CGRect(x: scale * index, y: 0, width: 1, height: length)) // vertical lines
                    context.fill(CGRect(x: 0, y: scale * index, width: length, height: 1)) // horizontal lines
                }
            })
    }
}

struct BoardRender_Previews: PreviewProvider {
    static var previews: some View {
        view(preset: .nebura, colorScheme: .dark)
        view(preset: .nebura, colorScheme: .light)
        view(preset: .spaceShip, colorScheme: .dark)
    }

    static func view(preset: BoardPreset, colorScheme: ColorScheme) -> some View {
        BoardRenderImage(
            board: preset.board.board,
            cellRenderSize: 10,
            cellColor: colorScheme == .dark ? .white : .black
        )
        .previewLayout(.fixed(width: 200.0, height: 200.0))
        .colorScheme(colorScheme)
        .preferredColorScheme(colorScheme)
        .padding()
    }
}
