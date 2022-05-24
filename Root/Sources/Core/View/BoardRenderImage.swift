//
//  BoardRenderImage.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/14.
//

import SwiftUI
import LifeGame

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
        let scale = CGFloat(cellRenderSize)
        let boardSize = CGFloat(board.size)
        let renderWidth = boardSize * scale + 1

        ZStack {
            Canvas { canvasContext, size in
                canvasContext.scaleBy(x: size.width / renderWidth, y: size.height / renderWidth)
                canvasContext.withCGContext { context in
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
                            let x = CGFloat(index % board.size) * scale
                            let y = CGFloat(index / board.size) * scale
                            context.fill(CGRect(origin: CGPoint(x: x + 1, y: y + 1), size: CGSize(width: scale - 1, height: scale - 1)))
                        }
                    }
                }
            }
            
            BoardGridImage(cellRenderSize: cellRenderSize, boardSize: board.size)
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
