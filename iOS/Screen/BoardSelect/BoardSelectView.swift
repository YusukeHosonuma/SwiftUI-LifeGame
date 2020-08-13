//
//  BoardListView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/06.
//

import SwiftUI
import LifeGame
import FirebaseFirestore
import FirebaseFirestoreSwift

struct BoardSelectView<Repository: FirestoreBoardRepositoryProtorol> : View {
    @EnvironmentObject var setting: SettingEnvironment
    
    @ObservedObject var repository: Repository // TODO: @EnvironmentObject で受け取れるようにできる❓
    @Binding var isPresented: Bool
    @State private var isStarOnly = false

    // MARK: Computed properties
    
    private var fileredItems: [BoardDocument] {
        repository.items
            .filter { isStarOnly ? $0.stared : true }
    }
    
    // MARK: View

    var body: some View {
        NavigationView {
            Group {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(fileredItems, id: \.id!) { item in
                            Button(action: { tapCell(board: item) }) {
                                BoardSelectCell(item: item, style: setting.boardSelectDisplayStyle)
                            }
                            .contextMenu { // beta4 時点だとコンテンツ自体が半透明になって見づらくなる問題あり❗
                                cellContextMenu(item: item)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Select board", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel", action: tapCancel),
                                trailing: menu())
        }
    }

    private var columns: [GridItem] {
        switch setting.boardSelectDisplayStyle {
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
    
    private func menu() -> some View {
        Menu(content: {
            Picker(selection: $setting.boardSelectDisplayStyle, label: Text("Picker Name")) {
                ForEach(BoardSelectStyle.allCases, id: \.rawValue) { style in
                    Label(style.text, systemImage: style.imageName)
                        .tag(style)
                }
            }
            
            Divider()
            
            Toggle(isOn: $isStarOnly) {
                Label("Star only", systemImage: "star.fill")
            }
        }, label: {
            Image(systemName: "ellipsis.circle")
        })
    }
    
    private func cellContextMenu(item: BoardDocument) -> some View {
        Button(action: { toggleStared(item) }) {
            if item.stared {
                Text("お気に入り解除")
                Image(systemName: "star.slash")
            } else {
                Text("お気に入り")
                Image(systemName: "star")
            }
        }
    }
    
    // MARK: Actions
    
    private func toggleStared(_ document: BoardDocument) {
        var newDocument = document
        newDocument.stared.toggle()
        repository.update(newDocument)
    }
    
    private func tapCancel() {
        isPresented = false
    }
    
    private func tapCell(board document: BoardDocument) {
        let board = document.makeBoard()
        LifeGameContext.shared.setBoard(board) // TODO: refactor
        isPresented = false
    }
}

struct BoardSelectView_Previews: PreviewProvider {
    static var previews: some View {
        BoardSelectView(repository: DesigntimeFirestoreBoardRepository(), isPresented: .constant(true))

        // Note:
        // Sheet style is not working in normal-preview (when live-preview is working) in beta4❗
        //
        // ```
        // EmptyView()
        //     .sheet(isPresented: .constant(true)) {
        //         BoardListView(isPresented: .constant(true), boardDocuments: boards)
        //     }
        // ```
    }
}
