//
//  PatterndGridLoadView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import SwiftUI

struct PatternGridLoadView: View {
    @StateObject private var loader: PatternLoader
    private var isSignIn: Bool
    private var didTap: (BoardItem) -> Void
    private var didToggleStar: (BoardItem) -> Void

    @State private var isPresentedAlertNeedLogin = false

    init(url: URL,
         isSignIn: Bool,
         didTap: @escaping (BoardItem) -> Void,
         didToggleStar: @escaping (BoardItem) -> Void
    ) {
        _loader = StateObject(wrappedValue: PatternLoader(url: url))
        self.isSignIn = isSignIn
        self.didTap = didTap
        self.didToggleStar = didToggleStar
    }
    
    var body: some View {
        if let board = loader.board {
            PatternGridView(board: board)
                .onTapGesture {
                    didTap(board)
                }
                .contextMenu {
                    BoardSelectContextMenu(
                        isStared: .init(get: { board.stared },
                                        set: { didSetStared(value: $0, board: board) })
                    )
                }
                .alert(isPresented: $isPresentedAlertNeedLogin) {
                    Alert(title: Text("Need login."))
                }
        } else {
            PatternGridView.placeHolder()
        }
    }
    
    // MARK: Action
    
    private func didSetStared(value: Bool, board: BoardItem) {
        if isSignIn {
            withAnimation {
                didToggleStar(board)
                loader.refresh()
            }
        } else {
            self.isPresentedAlertNeedLogin.toggle()
        }
    }
}

struct PatterndGridLoadView_Previews: PreviewProvider {
    static var previews: some View {
        PatternGridLoadView(url: URL(string: "https://lifegame-dev.web.app/pattern/$rats.json")!,
                         isSignIn: true,
                         didTap: { _ in },
                         didToggleStar: { _ in })
    }
}
