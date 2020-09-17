//
//  AllBoardSelectView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/24.
//

import SwiftUI

// Note: ✅
// やや早すぎる抽象化だとは感じるが、とりあえず実験的な意味も込めて。

struct AllBoardSelectView: View {
    @EnvironmentObject private var boardStore: BoardStore
    @EnvironmentObject private var authentication: Authentication
    
    private var displayStyle: BoardSelectStyle
    private var isFilterByStared: Bool
    private var didSelect: (BoardItem) -> Void
    
    @State private var isPresentedAlert = false
    
    // MARK: Initializer
    
    init(displayStyle: BoardSelectStyle,
         isFilterByStared: Bool,
         didSelect: @escaping (BoardItem) -> Void
    ) {
        self.displayStyle = displayStyle
        self.isFilterByStared = isFilterByStared
        self.didSelect = didSelect
    }
    
    // MARK: Computed Properties
    
    // TODO: テストしやすさを考えるとこういうロジックはViewから切り離したほうが良いのかもしれない。
    private var fileredItems: [BoardItem] {
        boardStore.allBoards
            .filter(when: authentication.isSignIn && isFilterByStared, isIncluded: \.stared)
    }
    
    private var columns: [GridItem] {
        switch displayStyle {
        case .grid:
            return [
                GridItem(.adaptive(minimum: 100))
            ]

        case .list:
            return [
                GridItem(spacing: 0)
            ]
        }
    }
    
    // MARK: View
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(fileredItems) { item in
                BoardSelectCell(item: item, style: displayStyle)
                    .onTapGesture {
                        didSelect(item)
                    }
                    .contextMenu {
                        BoardSelectContextMenu(isStared: .init(get: { item.stared }, set: { _ in
                            if authentication.isSignIn {
                                withAnimation {
                                    //self.boardStore.toggleLike(boardID: item.boardDocumentID)
                                }
                            } else {
                                isPresentedAlert.toggle()
                            }
                        }))
                    }
            }
        }
        .padding([.horizontal])
        .alert(isPresented: $isPresentedAlert) {
            Alert(title: Text("Need login."))
        }
    }
    
    // Note:
    // `.sheet`で表示されたビューに対して`.toolbar`が機能しない。NavigationViewで囲っても同様。（macOS-beta 5）❗
    //
    // ```
    // .toolbar {
    //     ToolbarItem(placement: .cancellationAction) {
    //         Button("Cancel") {}
    //     }
    // }
    // ```
}

//struct AllBoardSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllBoardSelectView()
//    }
//}
