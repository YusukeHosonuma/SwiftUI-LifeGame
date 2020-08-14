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
        GeometryReader { geometry in
            VStack {
                BoardRenderImage(board: viewModel.board.board, cellRenderSize: cellRenderSize)
                    .border(Color.gray, width: 2)
                    .scaleEffect(latestScale * currentScale)
                    .offset(x: offset.x, y: offset.y)
                    .gesture(dragGesture())
                    // Not working in real devices (beta 4)❗
                    // https://developer.apple.com/forums/thread/653022
                    .simultaneousGesture(magnificationGesture())
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
        }
    }

    // MARK: Gestures
    
    private func dragGesture() -> some Gesture {
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

                let viewSize = CGFloat(viewModel.board.size * cellRenderSize)
                let renderSize = viewSize * scale
                let space = (renderSize - viewSize) / 2
                let x = (space + tapX - offset.x) / scale
                let y = (space + tapY - offset.y) / scale
             
                let indexX = Int(x / CGFloat(cellRenderSize))
                let indexY = Int(y / CGFloat(cellRenderSize))
                
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
