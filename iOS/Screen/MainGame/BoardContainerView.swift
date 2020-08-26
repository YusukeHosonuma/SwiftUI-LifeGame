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
    @EnvironmentObject var boardManager: BoardManager
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
                    board: boardManager.board.board,
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
            .simultaneousGesture(magnificationGesture(boardViewSize: geometry.size.width))
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
                let x = value.location.x - value.startLocation.x
                let y = value.location.y - value.startLocation.y
                
                // Make board keep in the range.
                let renderSize = boardViewSize * scale
                var space = (renderSize - boardViewSize) / 2
                if scale < 1.0 {
                    space = -space
                }
                currentPoint = CGPoint(x: within(value: x, min: -space - latestPoint.x, max: space - latestPoint.x),
                                       y: within(value: y, min: -space - latestPoint.y, max: space - latestPoint.y))
            }
            .onEnded { value in
                //
                // Drag event
                //
                if scale < 1.0 {
                    // Adjust point to origin point.
                    withAnimation {
                        latestPoint = CGPoint.zero
                        currentPoint = CGPoint.zero
                    }
                } else {
                    updatePoint()
                }

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
             
                let cellSize = boardViewSize / CGFloat(boardManager.board.size)
                let indexX = Int(x / cellSize)
                let indexY = Int(y / cellSize)

                boardManager.tapCell(x: within(value: indexX, min: 0, max: boardManager.board.size - 1),
                                     y: within(value: indexY, min: 0, max: boardManager.board.size - 1))
            }
    }
    
    private func magnificationGesture(boardViewSize: CGFloat) -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                currentScale = max(value, minScale)
                
                // Scale from the center of visual range.
                let x = latestPoint.x * currentScale
                let y = latestPoint.y * currentScale
                currentPoint = CGPoint(x: x - latestPoint.x, y: y - latestPoint.y)
            }
            .onEnded { value in
                updateScale()
                updatePoint()

                // Adjust the board to stay within range.
                withAnimation {
                    let renderSize = boardViewSize * latestScale
                    let space = (renderSize - boardViewSize) / 2
                    if latestScale < 1.0 {
                        latestPoint = CGPoint.zero
                    } else {
                        latestPoint = CGPoint(x: within(value: latestPoint.x, min: -space, max: space),
                                              y: within(value: latestPoint.y, min: -space, max: space))
                    }
                }
            }
    }
    
    // Private
    
    private func updateScale() {
        latestScale *= currentScale
        currentScale = 1
    }
    
    private func updatePoint() {
        latestPoint = CGPoint(x: latestPoint.x + currentPoint.x, y: latestPoint.y + currentPoint.y)
        currentPoint = CGPoint.zero
    }
}
