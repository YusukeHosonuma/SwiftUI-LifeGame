//
//  BoardListView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/06.
//

import SwiftUI
import LifeGame
import Network

struct BoardSelectView<BoardStore>: View where BoardStore: BoardStoreProtocol {
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var network: NetworkMonitor
    @EnvironmentObject var authentication: Authentication

    @ObservedObject var boardStore: BoardStore
    @Binding var isPresented: Bool

    // MARK: Computed properties
    
    private var fileredItems: [BoardItem] {
        boardStore.allBoards
            .filter(when: setting.isFilterByStared) { $0.stared }
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

    // Note:
    // 実機で2回目のレンダリング実行時に`NetworkMonitor`が見つからなくてクラッシュする不具合がある。（beta4時点）❗
    // 以下のような解決情報もあるが、現時点では仕様かどうかの見極めがつかないので一旦コメントアウト（実際、SettingEnvironment は問題ない）
    // https://qiita.com/usk2000/items/1f8038dedf633a31dd78

    // Note:
    // 既にプリセットが取得できている場合はオフラインでも何も表示しない。
    // if network.status != .satisfied && repository.items.isEmpty {
    //     Text("Network is offline.")
    //         .foregroundColor(.secondary)
    //         .padding()
    // } else {
    // }
    
    // MARK: View

    var body: some View {
        NavigationView {
            // Note:
            // Sectionでヘッダーを表示しようとするとレイアウトが壊れてしまう（beta4）❗
            // LazyVGrid と競合しているようだが、現時点では仕様かバグの判断がつかないため保留。
            //
            // ```
            // List {
            //     Section(header: Text("History")) { ... }
            //     Section(header: Text("All")) { ... }
            // }
            // ```
            ScrollView {
                VStack {
                    // Note:
                    // ここで`VStack`をもう一度利用しようとするとクラッシュする（beta4）❗
                    header(title: "History")
                    BoardSelectHistoryView(
                        isSignIn: authentication.isSignIn,
                        items: boardStore.histories,
                        toggleStar: { boardID in
                            self.boardStore.toggleLike(boardID: boardID)
                        },
                        tapItem: tapHistoryCell)
                    
                    header(title: "All")
                    LazyVGrid(columns: columns, pinnedViews: [.sectionHeaders]) {
                        ForEach(fileredItems) { item in
                            Button(action: { tapCell(item) }) {
                                BoardSelectCell(item: item, style: setting.boardSelectDisplayStyle)
                            }
                            .contextMenu { // beta4 時点だとコンテンツ自体が半透明になって見づらくなる問題あり❗
                                BoardSelectContextMenu(isStared: item.stared) {
                                    withAnimation {
                                        self.boardStore.toggleLike(boardID: item.boardDocumentID)
                                    }
                                }
                            }
                        }
                    }
                    .padding([.horizontal])
                }
            }
            .navigationBarTitle("Select board", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel", action: tapCancel),
                                trailing: menu())
        }
    }

    private func header(title: String) -> some View {
        HStack {
            Text(title)
            Spacer()
        }
        .font(.headline)
        .padding([.top, .horizontal])
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
            
            Toggle(isOn: $setting.isFilterByStared) {
                Label("Star only", systemImage: "star.fill")
            }
        }, label: {
            Image(systemName: "ellipsis.circle")
        })
    }
    
    // MARK: Actions

    private func tapCancel() {
        dismiss()
    }

    private func tapHistoryCell(_ item: BoardHistoryItem) {
        selectBoard(boardDocumentID: item.boardDocumentID, board: item.board)
    }
    
    private func tapCell(_ item: BoardItem) {
        selectBoard(boardDocumentID: item.boardDocumentID, board: item.board)
    }
    
    private func selectBoard(boardDocumentID: String, board: Board<Cell>) {
        if let user = authentication.user {
            boardStore.addToHistory(boardID: boardDocumentID, user: user)
        }
        LifeGameContext.shared.setBoard(board) // TODO: refactor
        dismiss()
    }
    
    private func dismiss() {
        isPresented = false
    }
}

//struct BoardSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        view(networkStatus: .satisfied,   dataFetched: true,  description: "Normal case.")
//        view(networkStatus: .unsatisfied, dataFetched: false, description: "Data is not fetched and network is offline.")
//        view(networkStatus: .satisfied,   dataFetched: false, description: "Wait to fetch data.")
//    }
//
//    // Note:
//    // Sheet style is not working in normal-preview (when live-preview is working) in beta4❗
//    //
//    // ```
//    // EmptyView()
//    //     .sheet(isPresented: .constant(true)) {
//    //         BoardListView(isPresented: .constant(true), boardDocuments: boards)
//    //     }
//    // ```
//
//    static func view(networkStatus: NWPath.Status, dataFetched: Bool, description: String) -> some View {
//        let repository = dataFetched ? DesigntimeFirestoreBoardRepository() : DesigntimeFirestoreBoardRepository(documents: [])
//        
//        return VStack {
//            Text(description)
//                .foregroundColor(.red)
//                .font(.subheadline)
//                .bold()
//                .padding()
//            HStack {
//                BoardSelectView(repository: repository, historyRepository: .shared, isPresented: .constant(true))
//                    .environmentObject(SettingEnvironment.shared)
//                    .environmentObject(NetworkMonitor(mockStatus: networkStatus))
//                    .colorScheme(.dark) // preferredColorScheme だと期待どおりに動かない（beta 4）❗
//                BoardSelectView(repository: repository, historyRepository: .shared, isPresented: .constant(true))
//                    .environmentObject(SettingEnvironment.shared)
//                    .environmentObject(NetworkMonitor(mockStatus: networkStatus))
//                    .colorScheme(.light)
//            }
//        }
//        .previewLayout(.fixed(width: 800, height: 300))
//    }
//}
