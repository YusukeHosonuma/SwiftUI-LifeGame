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
    @Environment(\.colorScheme) var colorScheme

    // MARK: Private properties
    
    @State private var currentScale: CGFloat = 1
    @State private var latestScale: CGFloat = 1
    @State private var latestPoint = CGPoint.zero
    @State private var currentPoint = CGPoint.zero

    private let cellRenderSize: Int = 10
    private let minScale: CGFloat = 0.5

    private var scale: CGFloat {
        latestScale * currentScale
    }
    
    private var offset: CGPoint {
        CGPoint(x: latestPoint.x + currentPoint.x, y: latestPoint.y + currentPoint.y)
    }
    
    // MARK: Views
    
    var body: some View {
        #if os(iOS)
        AppLogger.imageLoadBug.notice("BoardContainerView.body: \(setting.backgroundImage == nil ? "nil" : "found!", privacy: .public)")
        #endif
        return GeometryReader { geometry in
            ZStack {
                #if os(iOS)
                if let image = setting.backgroundImage {
                    Image(image: image)
                        .resizable()
                        .scaledToFill()
                        .opacity(0.7)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
                #endif
                BoardRenderImage(
                    board: viewModel.board.board,
                    cellRenderSize: cellRenderSize,
                    cellColor: cellColor
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .clipped()
            .border(Color.gray, width: 2)
            .scaleEffect(latestScale * currentScale)
            .offset(x: offset.x, y: offset.y)
            .gesture(dragGesture(boardViewSize: geometry.size.width))
            // Not working in real devices (beta 5)❗
            // https://developer.apple.com/forums/thread/653022
            .simultaneousGesture(magnificationGesture())
        }
        .clipped()
    }
    
    private var cellColor: Color {
        colorScheme == .dark
            ? setting.darkModeColor
            : setting.lightModeColor
    }

    // MARK: Gestures
    
    private func dragGesture(boardViewSize: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                //
                // Drag event
                //
                currentPoint = CGPoint(x: value.location.x - value.startLocation.x,
                                       y: value.location.y - value.startLocation.y)
            }
            .onEnded { value in
                //
                // Drag event
                //
                latestPoint = CGPoint(x: latestPoint.x + currentPoint.x, y: latestPoint.y + currentPoint.y)
                currentPoint = CGPoint.zero

                guard value.location == value.startLocation else { return }
                
                //
                // Tap event
                //
                let tapX = value.location.x
                let tapY = value.location.y

                let renderSize = boardViewSize * scale
                let space = (renderSize - boardViewSize) / 2
                let x = (space + tapX - offset.x) / scale
                let y = (space + tapY - offset.y) / scale
             
                let cellSize = boardViewSize / CGFloat(viewModel.board.size)
                let indexX = Int(x / cellSize)
                let indexY = Int(y / cellSize)

                viewModel.tapCell(x: within(value: indexX, min: 0, max: viewModel.board.size - 1),
                                  y: within(value: indexY, min: 0, max: viewModel.board.size - 1))
            }
    }
    
    private func magnificationGesture() -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                currentScale = max(value, minScale)
            }
            .onEnded { value in
                latestScale *= currentScale
                currentScale = 1
            }
    }
}
