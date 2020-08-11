//
//  BoardThumbnailImage.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/09.
//

import SwiftUI
import LifeGame

struct BoardThumbnailImage: View {
    @Environment(\.colorScheme) var colorScheme
    
    var board: Board<Cell>
    
    var body: some View {
        Image(uiImage: thumbnailImage)
            .antialiased(false)
            .resizable()
            .scaledToFit()
    }
    
    private var fillColor: CGColor {
        colorScheme == .dark
            ? CGColor(red: 1, green: 1, blue: 1, alpha: 1)
            : CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    private var gridColor: CGColor {
        colorScheme == .dark
            ? CGColor(gray: 0.5, alpha: 0.3)
            : CGColor(gray: 0.5, alpha: 0.5)
    }

    private var thumbnailImage: UIImage {
        let scale = max(2, 200 / board.size)
        let size = CGSize(width: board.size * scale + 1, height: board.size * scale + 1)
        
        return UIGraphicsImageRenderer(size: size)
            .image(actions: { context in
                context.cgContext.setFillColor(fillColor)
                
                for (index, cell) in board.cells.enumerated() {
                    let x = (index % board.size) * scale
                    let y = (index / board.size) * scale
                    if cell == .alive {
                        context.fill(CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: scale, height: scale)))
                    }
                }
                
                // Draw grid
                context.cgContext.setFillColor(gridColor)
                for index in 0...board.size + 1 {
                    let length = board.size * scale + 1
                    context.fill(CGRect(x: scale * index, y: 0, width: 1, height: length)) // vertical lines
                    context.fill(CGRect(x: 0, y: scale * index, width: length, height: 1)) // horizontal lines
                }
            })
    }
}

struct BoardThumnailImage_Previews: PreviewProvider {
    static var previews: some View {
        view(preset: .nebura, colorScheme: .dark)
        view(preset: .nebura, colorScheme: .light)
        view(preset: .spaceShip, colorScheme: .dark)
    }
    
    static func view(preset: BoardPreset, colorScheme: ColorScheme) -> some View {
        BoardThumbnailImage(board: preset.board.board)
            .previewLayout(.fixed(width: 200.0, height: 200.0))
            .colorScheme(colorScheme)
            .preferredColorScheme(colorScheme)
            .padding()
    }
}
