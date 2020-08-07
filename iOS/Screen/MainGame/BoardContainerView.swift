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
        #if os(macOS)
        // TODO:
        EmptyView()
        #else
        if let image = setting.backgroundImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .opacity(0.8)
        } else {
            EmptyView()
        }
        #endif
    }
}
