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
    @Binding var isPresented: Bool

    // MARK: Computed properties
    
    private var fileredItems: [BoardDocument] {
        repository.items
            .filter(when: setting.isFilterByStared) { $0.stared }
    }
    
    // MARK: View

    var body: some View {
        NavigationView {
            Group {
                ScrollView {
                    // Note:
                    // 既にプリセットが取得できている場合はオフラインでも何も表示しない。
                    if network.status != .satisfied && repository.items.isEmpty {
                        Text("Network is offline.")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
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
    
    private func tapCell(board document: BoardDocument) {
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
                BoardSelectView(repository: repository, isPresented: .constant(true))
                    .environmentObject(SettingEnvironment.shared)
                    .environmentObject(NetworkMonitor(mockStatus: networkStatus))
                    .colorScheme(.dark) // preferredColorScheme だと期待どおりに動かない（beta 4）❗
                BoardSelectView(repository: repository, isPresented: .constant(true))
                    .environmentObject(SettingEnvironment.shared)
                    .environmentObject(NetworkMonitor(mockStatus: networkStatus))
                    .colorScheme(.light)
            }
        }
        .previewLayout(.fixed(width: 800, height: 300))
    }
}
