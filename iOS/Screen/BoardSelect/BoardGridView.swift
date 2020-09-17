//
//  BoardGridView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/16.
//

import SwiftUI
import FirebaseAuth
import Combine
import LifeGame

struct LifeWikiPattern: Codable, Identifiable {
    let title: String
    let patternType: String
    let rule: String
    let discoveredBy: String
    let yearOfDiscovery: String
    let width: Int
    let height: Int
    let cells: [Int]
    let sourceURL: URL
    
    var id: String {
        sourceURL.absoluteString.md5
    }
    
    func makeBoard() -> Board<Cell> {
        Board(
            width: width,
            height: height,
            cells: cells.map{ $0 == 0 ? Cell.die : Cell.alive },
            blank: Cell.die
        )
    }
}

final class PatternLoader: ObservableObject {
    @Published var board: BoardItem?
    
    private let url: URL
    private let patternService: PatternService = .shared
    private var cancellables: [AnyCancellable] = []
    
    init(url: URL) {
        self.url = url
        refresh()
    }
    
    func refresh() {
        patternService.fetch(from: url).assign(to: &$board)

    }
}

final class PatternStore: ObservableObject {
    @Published var allIds: [URL] = []
    @Published var staredIds: [URL] = []
    @Published var spaceshipIds: [URL] = []

    private let patternService: PatternService = .shared
    
    init() {
        patternService.patternURLs().assign(to: &$allIds)
        patternService.staredPatternURLs().assign(to: &$staredIds) // TODO: 最終的に Listen 形式に変える
        patternService.patternURLs(by: "Spaceship").assign(to: &$spaceshipIds)
    }
}

struct PatternSelectSheetView: View {
    @StateObject var store = PatternStore()
    @Binding var presented: Bool

    var body: some View {
        TabView {
            PatternGridListView(presented: $presented, patternURLs: store.allIds)
                .tabItem { Text("All") }
            PatternGridListView(presented: $presented, patternURLs: store.spaceshipIds)
                .tabItem { Text("Spaceship") }
            PatternGridListView(presented: $presented, patternURLs: store.staredIds)
                .tabItem { Text("Stared") }
        }
    }
}

struct PatternGridListView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var boardStore: BoardStore
    @EnvironmentObject var authentication: Authentication
    
    @Binding var presented: Bool
    var patternURLs: [URL]
    
    private var columns: [GridItem] {
        return [
            GridItem(.adaptive(minimum: 100))
        ]
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(patternURLs, id: \.self) { url in
                    PatterndGridView(
                        url: url,
                        isSignIn: authentication.isSignIn,
                        didTap: didTapItem,
                        didToggleStar: didToggleStar
                    )
                    .frame(width: 100, height: 100, alignment: .center)
                }
            }
        }
    }
    
    // MARK: Action
    
    private func didTapItem(item: BoardItem) {
//        if authentication.isSignIn {
//            boardStore.addToHistory(boardID: boardDocumentID)
//        }
        gameManager.setBoard(board: item.board)
        self.presented = false
    }
    
    private func didToggleStar(item: BoardItem) {
        boardStore.toggleLike(to: item)
    }
}

struct PatterndGridView: View {
    @StateObject private var loader: PatternLoader
    private var isSignIn: Bool
    private var didTap: (BoardItem) -> Void
    private var didToggleStar: (BoardItem) -> Void

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
            VStack {
                BoardThumbnailImage(board: board.board, cacheKey: board.id)
                HStack {
                    Text(board.title)
                        .lineLimit(1)
                        .foregroundColor(.accentColor)
                    Spacer()
                    if board.stared {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
                .font(.system(.caption, design: .monospaced))
            }
            .onTapGesture {
                didTap(board)
            }
            .contextMenu {
                BoardSelectContextMenu(isStared: .init(get: { board.stared }, set: { _ in
                    if isSignIn {
                        withAnimation {
                            didToggleStar(board)
                            loader.refresh()
                        }
                    }
//                    else {
//                        isPresentedAlert.toggle()
//                    }
                }))
            }
        } else {
            ProgressView()
        }
    }
}

struct PatterndGridView_Previews: PreviewProvider {
    static var previews: some View {
        PatterndGridView(url: URL(string: "https://lifegame-dev.web.app/pattern/$rats.json")!,
                         isSignIn: true,
                         didTap: { _ in },
                         didToggleStar: { _ in })
    }
}
