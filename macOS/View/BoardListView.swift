//
//  BoardListView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/24.
//

import SwiftUI
import LifeGame

struct BoardListView: View {
    @EnvironmentObject private var setting: SettingEnvironment
    @EnvironmentObject private var authentication: Authentication
    @EnvironmentObject private var boardStore: BoardStore
    @EnvironmentObject private var gameManager: GameManager

    @Binding private var isPresented: Bool

    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            List {
                // Note:
                // 画面上部ギリギリに設置されてしまい`.padding`も効かない（macOS-beta5）❗
                Section(header: Text("Search options")) {
                    Toggle("Star only", isOn: $setting.isFilterByStared.animation())
                        .enabled(authentication.isSignIn)
                }
            }
            .listStyle(SidebarListStyle())
            
            VStack {
                Text("Select board")
                    .font(.title)
                    .padding()
                
                ScrollView {
                    AllBoardSelectView(
                        displayStyle: .grid,
                        isFilterByStared: setting.isFilterByStared,
                        didSelect: didSelect
                    )
                }

                Button("Cancel", action: dismiss)
                    .padding()
            }
            .padding()
        }
    }
    
    // MARK: Action

    private func didSelect(item: BoardItem) {
        if authentication.isSignIn {
            boardStore.addToHistory(boardID: item.boardDocumentID)
        }
        gameManager.setBoard(board: item.board)
        dismiss()
    }
    
    private func dismiss() {
        isPresented = false
    }
}

struct BoardListView_Previews: PreviewProvider {
    static var previews: some View {
        BoardListView(isPresented: .constant(true))
    }
}
