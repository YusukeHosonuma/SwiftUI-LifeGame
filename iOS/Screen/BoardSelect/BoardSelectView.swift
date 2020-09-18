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
    @EnvironmentObject var gameManager: GameManager

    @ObservedObject var boardStore: BoardStore
    @Binding var isPresented: Bool

    // MARK: View

    var body: some View {
        NavigationView {
            // Note:
            //
            // Sectionでヘッダーを表示した場合、コンテキストメニューがシート全体に対するものになってしまう（beta 6）❗
            //
            // ```
            // List {
            //     Section(header: Text("History")) { ... }
            //     Section(header: Text("All")) { ... }
            // }
            // .listStyle(InsetListStyle())
            // ```
            //
            ScrollView {
                VStack {
                    historySection()
                    allSection()
                }
            }
            .navigationTitle("Select board")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: tapCancel)
                }
            }
        }
    }
    
    @ViewBuilder
    private func historySection() -> some View {
        VStack {
            HStack {
                Text("History")
                Spacer()
            }
            .sectionHeader()
            
            VStack {
                if authentication.isSignIn {
                    BoardSelectHistoryView(
                        items: boardStore.histories,
                        toggleStar: { boardID in
                            //self.boardStore.toggleLike(boardID: boardID)
                        },
                        tapItem: tapHistoryCell
                    )
                } else {
                    Text("Need login.").emptyContent()
                }
            }
            .frame(height: 100)
        }
    }

    @ViewBuilder
    private func allSection() -> some View {
        HStack {
            Text("All")
            Spacer()
            menuButton()
        }
        .sectionHeader()
        
        if network.status != .satisfied && boardStore.allBoards.isEmpty {
            Text("Network is offline.").emptyContent()
        } else {
            AllBoardSelectView(displayStyle: setting.boardSelectDisplayStyle,
                               isFilterByStared: setting.isFilterByStared,
                               didSelect: tapCell)
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
            
            if authentication.isSignIn {
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
    
    private func tapCell(_ item: PatternItem) {
        selectBoard(boardDocumentID: item.patternID, board: item.board)
    }
    
    private func selectBoard(boardDocumentID: String, board: Board<Cell>) {
//        if authentication.isSignIn {
//            boardStore.addToHistory(boardID: boardDocumentID)
//        }
        gameManager.setBoard(board: board)
        dismiss()
    }
    
    private func dismiss() {
        isPresented = false
    }
}

private extension View {
    func sectionHeader() -> some View {
        self.font(.headline).padding([.top, .horizontal])
    }
}
/*
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
                BoardSelectView(boardStore: boardStore, isPresented: .constant(true))
                    .environmentObject(SettingEnvironment.shared)
                    .environmentObject(NetworkMonitor(mockStatus: networkStatus))
                    .environmentObject(Authentication(mockSignIn: isSignIn))
                    .colorScheme(.dark) // preferredColorScheme だと期待どおりに動かない（beta4）❗
            }
            VStack {
                Text(description)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .bold()
                    .padding()
                BoardSelectView(boardStore: boardStore, isPresented: .constant(true))
                    .environmentObject(SettingEnvironment.shared)
                    .environmentObject(NetworkMonitor(mockStatus: networkStatus))
                    .environmentObject(Authentication(mockSignIn: isSignIn))
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
*/
