//
//  PatternGridListView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import SwiftUI

extension PatternGridListView {
    enum Style {
        case grid
        case horizontal
    }
}

struct PatternGridListView: View {
    @EnvironmentObject var authentication: Authentication
    
    var style: Style
    var patternURLs: [URL]
    var didTapItem: (PatternItem) -> Void
    var didToggleStar: (PatternItem) -> Void

    var body: some View {
        switch style {
        case .grid:
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    content()
                }
                .padding(16)
            }
            .padding(-16)
            
        case .horizontal:
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(100))]) {
                    ForEach(patternURLs, id: \.self) { url in
                        PatternGridLoadView(
                            url: url,
                            isSignIn: authentication.isSignIn,
                            didTap: didTapItem,
                            didToggleStar: didToggleStar
                        )
                        .frame(width: 100) // TODO: タイトルの長さに横幅が伸びてしまうので暫定
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, -16)
        }
    }
    
    func content() -> some View {
        ForEach(patternURLs, id: \.self) { url in
            PatternGridLoadView(
                url: url,
                isSignIn: authentication.isSignIn,
                didTap: didTapItem,
                didToggleStar: didToggleStar
            )
        }
    }
}
