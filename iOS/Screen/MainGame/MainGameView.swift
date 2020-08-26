//
//  MainGameView.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import SwiftUI
import LifeGame
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - Main view

struct MainGameView: View {
    @EnvironmentObject var boardManager: BoardManager

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HeaderView(generation: boardManager.board.generation, size: boardManager.board.size)
                .padding([.horizontal])

                Spacer()
                
                BoardContainerView()
                    .frame(width: geometry.size.width, height: geometry.size.width)
                
                Spacer()
                
                ControlView()
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
        MainGameView()
            .previewDevice("iPhone SE (2nd generation)")
            .preferredColorScheme(colorScheme)
    }
}
