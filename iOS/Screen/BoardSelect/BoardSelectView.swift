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

    var isSignIn: Bool
    @ObservedObject var boardStore: BoardStore
    @Binding var isPresented: Bool
    
    // MARK: Computed properties
    
    private var fileredItems: [BoardItem] {
        boardStore.allBoards
            .filter(when: isSignIn && setting.isFilterByStared, isIncluded: \.stared)
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
    @State var isPresentedAlert = false

    // MARK: View

    var body: some View {
        NavigationView {
            // Note:
            // Sectionでヘッダーを表示した場合、コンテキストメニューがSectionの領域全体に対するものになってしまう（beta4）❗
            //
            // ```
            // List {
            //     Section(header: Text("History")) { ... }
            //     Section(header: Text("All")) { ... }
            // }
            // .listStyle(InsetListStyle())
            // ```
            ScrollView {
                VStack {
                    // Note:
                    // ここで`VStack`をもう一度利用しようとするとクラッシュする。paddingで調整すれば問題ないが（beta4）❗
                    header(title: "History")
                    BoardSelectHistoryView(
                        isSignIn: isSignIn,
                        items: boardStore.histories,
                        toggleStar: { boardID in
                            self.boardStore.toggleLike(boardID: boardID)
                        },
                        tapItem: tapHistoryCell)
                    
                    
                    HStack {
                        Text("All")
                        Spacer()
                        menuButton()
                    }
                    .font(.headline)
                    .padding([.top, .horizontal])

                    LazyVGrid(columns: columns) {
                        ForEach(fileredItems) { item in
                            Button(action: { tapCell(item) }) {
                                BoardSelectCell(item: item, style: setting.boardSelectDisplayStyle)
                            }
                            .contextMenu { // beta4 時点だとコンテンツ自体が半透明になって見づらくなる問題あり❗
                                BoardSelectContextMenu(isStared: item.stared) {
                                    if isSignIn {
                                        withAnimation {
                                            self.boardStore.toggleLike(boardID: item.boardDocumentID)
                                        }
                                    } else {
                                        isPresentedAlert.toggle()
                                    }
                                }
                            }
                            .alert(isPresented: $isPresentedAlert) {
                                Alert(title: Text("Need login."))
                            }
                        }
                    }
                    .padding([.horizontal])
                }
            }
            .navigationBarTitle("Select board", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel", action: tapCancel))
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
    
    private func menuButton() -> some View {
        Menu(content: {
            Picker(selection: $setting.boardSelectDisplayStyle, label: Text("")) {
                ForEach(BoardSelectStyle.allCases, id: \.rawValue) { style in
                    Label(style.text, systemImage: style.imageName)
                        .tag(style)
                }
            }
            
            Divider()
            
            if isSignIn {
                Toggle(isOn: $setting.isFilterByStared) {
                    Label("Star only", systemImage: "star.fill")
                }
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
        if isSignIn {
            boardStore.addToHistory(boardID: boardDocumentID)
        }
        LifeGameContext.shared.setBoard(board) // TODO: refactor
        dismiss()
    }
    
    private func dismiss() {
        isPresented = false
    }
}

final class DesigntimeBoardStore: BoardStoreProtocol {
    @Published var allBoards: [BoardItem]
    @Published var histories: [BoardHistoryItem]
    
    init(allBoards: [BoardItem], histories: [BoardHistoryItem]) {
        self.allBoards = allBoards
        self.histories = histories
    }
    
    func toggleLike(boardID: String) {
        if let index = allBoards.firstIndex(where: { $0.id == boardID }) {
            var item = allBoards[index]
            item.stared.toggle()
            allBoards[index] = item
        }
        
        if let index = histories.firstIndex(where: { $0.id == boardID }) {
            var item = histories[index]
            item.isStared.toggle()
            histories[index] = item
        }
    }
    
    func addToHistory(boardID: String) {
    }
}

struct BoardSelectView_Previews: PreviewProvider {
    static var previews: some View {
        view("Normal case. (Sign-in)",
             isSignIn: true, networkStatus: .satisfied,   existHistory: true, dataFetched: true)
        
        view("Normal case. (Sign-out)",
             isSignIn: false, networkStatus: .satisfied,   existHistory: true, dataFetched: true)
        
        view("Data is not fetched and network is offline.",
             isSignIn: true, networkStatus: .unsatisfied, existHistory: true, dataFetched: false)
        
        view("Wait to fetch data.",
             isSignIn: true, networkStatus: .satisfied,   existHistory: true, dataFetched: false)
    }

    // Note:
    // Sheet style is not working in normal-preview (when live-preview is working) in beta4❗
    //
    // ```
    // EmptyView()
    //     .sheet(isPresented: .constant(true)) {
    //         BoardListView(isPresented: .constant(true), boardDocuments: boards)
    //     }
    // ```

    static func view(_ description: String, isSignIn: Bool, networkStatus: NWPath.Status, existHistory: Bool, dataFetched: Bool) -> some View {
        let boardStore = DesigntimeBoardStore(allBoards: dataFetched ? allBoards : [],
                                              histories: existHistory ? histories : [])
        
        return Group {
            VStack {
                Text(description)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .bold()
                    .padding()
                BoardSelectView(isSignIn: isSignIn, boardStore: boardStore, isPresented: .constant(true))
                    .environmentObject(SettingEnvironment.shared)
                    .environmentObject(NetworkMonitor(mockStatus: networkStatus))
                    .colorScheme(.dark) // preferredColorScheme だと期待どおりに動かない（beta 4）❗
            }
            VStack {
                Text(description)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .bold()
                    .padding()
                BoardSelectView(isSignIn: isSignIn, boardStore: boardStore, isPresented: .constant(true))
                    .environmentObject(SettingEnvironment.shared)
                    .environmentObject(NetworkMonitor(mockStatus: networkStatus))
                    .colorScheme(.light)
            }
        }
    }
    
    static let allBoards: [BoardItem] = [
        .init(boardDocumentID: "1", title: BoardPreset.nebura.displayText, board: BoardPreset.nebura.board.board, stared: true),
        .init(boardDocumentID: "2", title: BoardPreset.spaceShip.displayText, board: BoardPreset.spaceShip.board.board, stared: false),
    ]
    
    static let histories: [BoardHistoryItem] = [
        .init(historyID: "1", boardDocumentID: "1", title: BoardPreset.nebura.displayText, board: BoardPreset.nebura.board.board, isStared: true),
        .init(historyID: "2", boardDocumentID: "2", title: BoardPreset.spaceShip.displayText, board: BoardPreset.spaceShip.board.board, isStared: false),
    ]
}
