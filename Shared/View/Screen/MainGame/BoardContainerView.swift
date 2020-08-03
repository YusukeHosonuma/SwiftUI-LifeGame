//
//  BoardContainerView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/02.
//

import SwiftUI
import LifeGame

struct BoardContainerView: View {
    @EnvironmentObject var setting: SettingEnvironment
    @ObservedObject var viewModel: MainGameViewModel

    private let padding: CGFloat = 8
    
    var cellWidth: CGFloat {
        CGFloat(20 + (setting.zoomLevel - 5) * 2)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VCenter {
                HCenter {
                    boardView(geometry: geometry)
                }
            }
            .padding(padding)
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
    }
    
    @ViewBuilder
    private func boardView(geometry: GeometryProxy) -> some View {
        let boardView = BoardView(viewModel: viewModel, cellWidth: cellWidth, cellPadding: 1)
        let background = backgroundView()
            .frame(width: boardView.width, height: boardView.width)
            .clipped()
        
        if boardView.width + padding * 2 > geometry.size.width {
            ScrollView([.vertical, .horizontal], showsIndicators: false) {
                ZStack {
                    background
                    boardView
                }
            }
        } else {
            ZStack {
                background
                boardView
            }
        }
    }
    
    @ViewBuilder
    private func backgroundView() -> some View {
        if let image = setting.backgroundImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .opacity(0.8)
        } else {
            EmptyView()
        }
    }
}

struct BoardView: View {
    @ObservedObject var viewModel: MainGameViewModel
    
    var cellWidth: CGFloat
    var cellPadding: CGFloat

    // MARK: Computed properties
    
    var width: CGFloat {
        (cellWidth + (cellPadding * 2)) * CGFloat(viewModel.board.size) + 6
    }

    // MARK: Private

    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @EnvironmentObject private var setting: SettingEnvironment

    // MARK: View

    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.board.rows.withIndex(), id: \.0) { y, row in
                HStack(spacing: 0) {
                    ForEach(row.withIndex(), id: \.0) { x, cell in
                        cellButton(x: x, y: y, cell: cell)
                    }
                }
            }
        }
        .padding(3)
        .border(Color.gray, width: 2)
    }
    
    private func cellButton(x: Int, y: Int, cell: Cell) -> some View {
        CellView(color: cellBackgroundColor(cell: cell), size: cellWidth)
            .padding(cellPadding)
            .contentShape(Rectangle())
            .onTapGesture(perform: {
                viewModel.tapCell(x: x, y: y)
            })
    }
    
    private func cellBackgroundColor(cell: Cell) -> Color {
        switch (colorScheme, cell) {
        case (.light, .die):   return Color.clear
        case (.light, .alive): return setting.lightModeColor
        case (.dark,  .die):   return Color.clear
        case (.dark,  .alive): return setting.darkModeColor
        case (_, _):
            fatalError()
        }
    }
}
