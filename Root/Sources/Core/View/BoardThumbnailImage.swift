//
//  BoardThumbnailImage.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/09.
//

import SwiftUI
import LifeGame

#if os(macOS)
private typealias XImage = NSImage
#else
private typealias XImage = UIImage
#endif

private let cacheStorage = MemoryCacheStorage<XImage>()

// TODO: 内部的に BoardRenderImage を利用するようにしたい。

public struct BoardThumbnailImage: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.redactionReasons) var reasons
    
    private let board: Board<Cell>
    private let cellColor: Color?
    private let cacheKey: String?
    
    public init(board: Board<Cell>, cellColor: Color? = nil, cacheKey: String? = nil) {
        self.board = board.extended(by: .die, count: 1)
        self.cellColor = cellColor
        self.cacheKey = cacheKey
    }
    
    public var body: some View {
        let scale = max(2, 140 / board.size)
        let renderWidth = CGFloat(board.size * scale + 1)
        
        if reasons.isEmpty == false {
            // TODO: 外枠だけレンダリングしたほうがいいような？
            Color.gray.opacity(0.3)
                .scaledToFit()
        } else {
            Canvas { canvasContext, size in
                canvasContext.scaleBy(x: size.width / renderWidth, y: size.height / renderWidth)
                canvasContext.withCGContext { context in
                    context.setFillColor(fillColor)
                    
                    for (index, cell) in board.cells.enumerated() {
                        let x = (index % board.size) * scale
                        let y = (index / board.size) * scale
                        if cell == .alive {
                            context.fill(CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: scale, height: scale)))
                        }
                    }
                    
                    // Draw grid
                    context.setFillColor(gridColor)
                    for index in 0...board.size + 1 {
                        let length = board.size * scale + 1
                        context.fill(CGRect(x: scale * index, y: 0, width: 1, height: length)) // vertical lines
                        context.fill(CGRect(x: 0, y: scale * index, width: length, height: 1)) // horizontal lines
                    }
                }
            }
            .scaledToFit()
        }

        // TODO: いったん既存のキャッシュ処理は無効化（必要そうだったらまた考える）
        
//        Image(image: thumbnailImage)
//            .antialiased(false)
//            .resizable()
//            .scaledToFit()
    }
    
    // MARK: Private
    
    private var fillColor: CGColor {
        if let color = cellColor {
            return color.toCGColor()
        } else {
            return colorScheme == .dark
                ? Color.white.toCGColor()
                : Color.black.toCGColor()
        }
    }
    
    private var gridColor: CGColor {
        Color.gray.opacity(0.3).toCGColor()
    }
    
//    private var thumbnailImage: XImage {
//        guard let cacheKey = cacheKey else {
//            return renderImage()
//        }
//
//        let key = "\(cacheKey)-\(fillColor.hashValue)-\(gridColor.hashValue)"
//
//        if let image = cacheStorage.value(forKey: key) {
//            return image
//        } else {
//            let image = renderImage()
//            cacheStorage.store(key: key, image: image)
//            return image
//        }
//    }
//
//    private func renderImage() -> XImage {
//        let scale = max(2, 140 / board.size)
//        let size = CGSize(width: board.size * scale + 1, height: board.size * scale + 1)
//
//        return GraphicsImageRenderer(size: size)
//            .image(actions: { context in
//                context.setFillColor(fillColor)
//
//                for (index, cell) in board.cells.enumerated() {
//                    let x = (index % board.size) * scale
//                    let y = (index / board.size) * scale
//                    if cell == .alive {
//                        context.fill(CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: scale, height: scale)))
//                    }
//                }
//
//                // Draw grid
//                context.setFillColor(gridColor)
//                for index in 0...board.size + 1 {
//                    let length = board.size * scale + 1
//                    context.fill(CGRect(x: scale * index, y: 0, width: 1, height: length)) // vertical lines
//                    context.fill(CGRect(x: 0, y: scale * index, width: length, height: 1)) // horizontal lines
//                }
//            })
//    }
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
