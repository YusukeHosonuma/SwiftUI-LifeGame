//
//  BoardRenderImage.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/14.
//

import SwiftUI
import LifeGame

private let gridColor: CGColor = Color.gray.opacity(0.3).toCGColor()
private let borderWidth: CGFloat = 1.0 // FIXME: `1.0`だと 128 x 128 で一部の線が描画されない

public struct BoardRenderImage: View {
    private let board: Board<Cell>
    private let scale: CGFloat
    private let cellColor: CGColor
    
    public init(board: Board<Cell>, cellRenderSize: Int, cellColor: Color) {
        self.board = board
        self.scale = CGFloat(cellRenderSize)
        self.cellColor = cellColor.toCGColor()
    }
    
    public var body: some View {
        let boardSize = CGFloat(board.size)
        let renderWidth = boardSize * scale + 1

        Canvas { canvasContext, size in
            canvasContext.scaleBy(x: size.width / renderWidth, y: size.height / renderWidth)
            canvasContext.withCGContext(content: renderCells)
            canvasContext.withCGContext(content: renderGrid)
        }
    }
    
    // Note:
    // ライフゲームの性質上、空白のセルは多めになるので、その分だけ走査コストを減らすことができる。
    // （ただしその為には内部のデータ構造を見直す必要がある）
    //
    // しかし、パフォーマンス上のボトルネックがここなのか判断がつかないので、
    // Instruments でパフォーマンスを計測してから対応したほうがよさそう。
    private func renderCells(context: CGContext) {
        context.setFillColor(cellColor)
        
        for (index, cell) in board.cells.enumerated() {
            if cell == .alive {
                let x = CGFloat(index % board.size) * scale
                let y = CGFloat(index / board.size) * scale
                context.fill(CGRect(origin: CGPoint(x: x + 1, y: y + 1), size: CGSize(width: scale - 1, height: scale - 1)))
            }
        }
    }
    
    private func renderGrid(context: CGContext) {
        context.setFillColor(gridColor)

        for i in 0...board.size + 1 {
            let index = CGFloat(i)
            let length = CGFloat(board.size) * scale + borderWidth
            context.fill(CGRect(x: scale * index, y: 0, width: borderWidth, height: length)) // Vertical lines
            context.fill(CGRect(x: 0, y: scale * index, width: length, height: borderWidth)) // Horizontal lines
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
