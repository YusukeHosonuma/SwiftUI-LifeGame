//
//  BoardListView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/06.
//

import SwiftUI
import LifeGame
import Network

struct BoardSelectView<Repository: FirestoreBoardRepositoryProtorol> : View {
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var network: NetworkMonitor
        
    @ObservedObject var repository: Repository // TODO: @EnvironmentObject で受け取れるようにできる❓
    @ObservedObject var historyRepository: FirebaseHistoryRepository
    @Binding var isPresented: Bool

    // MARK: Computed properties
    
    private var fileredItems: [BoardDocument] {
        repository.items
            .filter(when: setting.isFilterByStared) { $0.stared }
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
            Group {
                // Note:
                // Sectionでヘッダーを表示しようとするとレイアウトが壊れてしまう（beta4）❗
                // LazyVGrid と競合しているようだが、現時点では仕様かバグの判断がつかないため保留。
                //
                // ```
                // List {
                //     Section(header: Text("History")) { ... }
                //     Section(header: Text("All")) { ... }
                // }
                //
                
                ScrollView {
                    VStack {
                        // Note:
                        // ここで`VStack`をもう一度利用しようとするとクラッシュする（beta4）❗
                        header(title: "History")
                        if historyRepository.items.isEmpty {
                            Text("No hitories")
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            ScrollView([.horizontal]) {
                                LazyHStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                                    ForEach(historyRepository.items, id: \.id) { item in
                                        Button(action: { tapCell(item.board) }) {
                                            historyCell(item: item.board)
                                        }
                                        .contextMenu { // beta4 時点だとコンテンツ自体が半透明になって見づらくなる問題あり❗
                                            cellContextMenu(item: item.board)
                                        }
                                    }
                                }
                                .padding([.horizontal, .bottom])
                            }
                        }

                        header(title: "All")
                        LazyVGrid(columns: columns, pinnedViews: [.sectionHeaders]) {
                            ForEach(fileredItems, id: \.id!) { item in
                                Button(action: { tapCell(item) }) {
                                    BoardSelectCell(item: item, style: setting.boardSelectDisplayStyle)
                                }
                                .contextMenu { // beta4 時点だとコンテンツ自体が半透明になって見づらくなる問題あり❗
                                    cellContextMenu(item: item)
                                }
                            }
                        }
                        .padding([.horizontal])
                    }
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
    
    private func historyCell(item: BoardDocument) -> some View {
        VStack(alignment: .leading) {
            BoardThumbnailImage(board: item.makeBoard(), cacheKey: item.id)
            Text(item.title)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .font(.system(.caption, design: .monospaced))
        .frame(width: 80)
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
            
            Toggle(isOn: $setting.isFilterByStared) {
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

    private func tapCell(_ document: BoardDocument) {
        let historyDocument = HistoryDocument(boardReference: document.reference)
        historyRepository.add(historyDocument)
        
        let board = document.makeBoard()
        LifeGameContext.shared.setBoard(board) // TODO: refactor
        isPresented = false
    }
}

struct BoardSelectView_Previews: PreviewProvider {
    static var previews: some View {
        view(networkStatus: .satisfied,   dataFetched: true,  description: "Normal case.")
        view(networkStatus: .unsatisfied, dataFetched: false, description: "Data is not fetched and network is offline.")
        view(networkStatus: .satisfied,   dataFetched: false, description: "Wait to fetch data.")
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

    static func view(networkStatus: NWPath.Status, dataFetched: Bool, description: String) -> some View {
        let repository = dataFetched ? DesigntimeFirestoreBoardRepository() : DesigntimeFirestoreBoardRepository(documents: [])
        
        return VStack {
            Text(description)
                .foregroundColor(.red)
                .font(.subheadline)
                .bold()
                .padding()
            HStack {
                BoardSelectView(repository: repository, historyRepository: .shared, isPresented: .constant(true))
                    .environmentObject(SettingEnvironment.shared)
                    .environmentObject(NetworkMonitor(mockStatus: networkStatus))
                    .colorScheme(.dark) // preferredColorScheme だと期待どおりに動かない（beta 4）❗
                BoardSelectView(repository: repository, historyRepository: .shared, isPresented: .constant(true))
                    .environmentObject(SettingEnvironment.shared)
                    .environmentObject(NetworkMonitor(mockStatus: networkStatus))
                    .colorScheme(.light)
            }
        }
        .previewLayout(.fixed(width: 800, height: 300))
    }
}
