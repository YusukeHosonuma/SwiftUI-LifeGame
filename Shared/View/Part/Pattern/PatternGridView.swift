//
//  PatternGridView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import SwiftUI

struct PatternGridView: View {
    let board: PatternItem
    
    static func placeHolder() -> some View {
        PatternGridView(
            board: PatternItem(patternID: "",
                               title: BoardPreset.nebura.displayText,
                               board: BoardPreset.nebura.board.board,
                               stared: false)
        )
        .redacted(reason: .placeholder)
    }
    
    var body: some View {
        VStack {
            HStack {
                BoardThumbnailImage(board: board.board, cacheKey: board.id)
                Spacer()
            }
            HStack {
                Text(board.title) // TODO: 画像サイズの横幅に一致させるようにしたい
                    .lineLimit(1)
                    .foregroundColor(.accentColor)
                Spacer()
                if board.stared {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
            .font(.system(.caption, design: .monospaced))
        }
    }
}
