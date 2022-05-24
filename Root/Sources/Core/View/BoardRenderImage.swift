//
//  BoardRenderImage.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/14.
//

import SwiftUI
import LifeGame

private let gridLineWidth: CGFloat = 1.5 // `1.0`だと 128 x 128 で一部の線が描画されない

public struct BoardRenderImage: View {
    private let board: Board<Cell>
    private let scale: CGFloat
    private let cellColor: Color
    
    public init(board: Board<Cell>, cellRenderSize: Int, cellColor: Color) {
        self.board = board
        self.scale = CGFloat(cellRenderSize)
        self.cellColor = cellColor
    }
    
    public var body: some View {
        let renderWidth = CGFloat(board.size) * scale + 1

        // Note:
        // ライフゲームの性質上、空白のセルは多めになるので、その分だけ走査コストを減らすことができる。
        // （ただしその為には内部のデータ構造を見直す必要がある）
        //
        // しかし、パフォーマンス上のボトルネックがここなのか判断がつかないので、
        // Instruments でパフォーマンスを計測してから対応したほうがよさそう。
        
        Canvas { context, size in
            context.scaleBy(x: size.width / renderWidth, y: size.height / renderWidth)
            
            //
            // Render cells.
            //
            for (index, cell) in board.cells.enumerated() {
                if cell == .alive {
                    let x = CGFloat(index % board.size) * scale + gridLineWidth
                    let y = CGFloat(index / board.size) * scale + gridLineWidth

                    context.fill(
                        Path(CGRect(
                            origin: CGPoint(x: x, y: y),
                            size: CGSize(width: scale - gridLineWidth, height: scale - gridLineWidth))
                        ),
                        with: .color(cellColor)
                    )
                }
            }
            
            //
            // Render grid.
            //
            for i in 0...board.size + 1 {
                let index = CGFloat(i)
                let length = CGFloat(board.size) * scale + gridLineWidth
                
                // Vertical lines
                context.fill(
                    Path(CGRect(x: scale * index, y: 0, width: gridLineWidth, height: length)),
                    with: .color(.gridLine)
                )

                // Horizontal lines
                context.fill(
                    Path(CGRect(x: 0, y: scale * index, width: length, height: gridLineWidth)),
                    with: .color(.gridLine)
                )
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
