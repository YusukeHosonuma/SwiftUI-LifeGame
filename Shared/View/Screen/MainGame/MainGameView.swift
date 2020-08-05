//
//  MainGameView.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import SwiftUI
import LifeGame

// MARK: - Main view

struct MainGameView: View {
    @ObservedObject var viewModel: MainGameViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HeaderView(generation: viewModel.board.generation, size: viewModel.board.size)
                .padding([.horizontal])

                Spacer()
                
                BoardContainerView(viewModel: viewModel)
                    .frame(width: geometry.size.width, height: geometry.size.width)
                
                Spacer()
                
                SpeedSliderView(viewModel: viewModel)
                    .padding([.horizontal])
                
                ControlView(viewModel: viewModel)
                    .padding()
            }
        }
    }
}

// MARK: - Preview

struct MainGameView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            view(.light)
            view(.dark)
        }
    }

    static func view(_ colorScheme: ColorScheme) -> some View {
        MainGameView(viewModel: MainGameViewModel())
            .previewDevice("iPhone SE (2nd generation)")
            .preferredColorScheme(colorScheme)
    }
}
