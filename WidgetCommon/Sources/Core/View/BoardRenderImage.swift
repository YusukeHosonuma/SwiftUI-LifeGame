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

public struct BoardRenderImage: View {
    let board: Board<Cell>
    let cellRenderSize: Int
    let cellColor: CGColor
    
    public init(board: Board<Cell>, cellRenderSize: Int, cellColor: Color) {
        self.board = board
        self.cellRenderSize = cellRenderSize
        self.cellColor = cellColor.toCGColor()
    }
    
    public var body: some View {
        ZStack {
            Image(image: renderImage())
                .resizable()
            BoardGridImage(cellRenderSize: cellRenderSize, boardSize: board.size)
        }
    }

    // MARK: Private
    
    private func renderImage() -> XImage {
        let scale = cellRenderSize
        let size = CGSize(width: board.size * scale + 1, height: board.size * scale + 1)
        
        return GraphicsImageRenderer(size: size)
            .image { context in
                context.setFillColor(cellColor)
                
                #warning("すべてのセルを走査してるためパフォーマンス的には悪い。")
                
                // Note:
                // ライフゲームの性質上、空白のセルは多めになるので、その分だけ走査コストを減らすことができる。
                // （ただしその為には内部のデータ構造を見直す必要がある）
                //
                // しかし、パフォーマンス上のボトルネックがここなのか判断がつかないので、
                // Instruments でパフォーマンスを計測してから対応したほうがよさそう。
                
                // Draw cells
                for (index, cell) in board.cells.enumerated() {
                    if cell == .alive {
                        let x = (index % board.size) * scale
                        let y = (index / board.size) * scale
                        context.fill(CGRect(origin: CGPoint(x: x + 1, y: y + 1), size: CGSize(width: scale - 1, height: scale - 1)))
                    }
                }
            }
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
