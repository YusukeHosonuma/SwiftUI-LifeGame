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
    @Published var urlsByCategory: [PatternCategory: [URL]] = [:]

    private let patternService: PatternService = .shared
    private var cancellables: [AnyCancellable] = []
    
    init() {
        patternService.patternURLs().assign(to: &$allIds)
        patternService.staredPatternURLs().assign(to: &$staredIds) // TODO: 最終的に Listen 形式に変える
        
        for category in PatternCategory.allCases {
            patternService
                .patternURLs(by: category.rawValue)
                .sink { urls in
                    self.urlsByCategory[category] = urls
                }
                .store(in: &cancellables)
        }
    }
}

struct PatternSelectSheetView: View {
    @StateObject var store = PatternStore()
    @Binding var presented: Bool

    var body: some View {
        NavigationView {
            TabView {
                PatternCategoryListView(store: store, presented: $presented)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Find")
                    }
                MyPatternListView(store: store, presented: $presented)
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("My Page")
                    }
            }
            .navigationTitle("Select pattern")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: tapCancel)
                }
            }
        }
    }
    
    // MARK: Actions

    private func tapCancel() {
        presented = false
    }
}

struct MyPatternListView: View {
    @ObservedObject var store: PatternStore
    @Binding var presented: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .leading) {
                    title("History")
                    PatternGridListView(
                        style: .horizontal,
                        presented: $presented,
                        patternURLs: store.urlsByCategory[.conduit] ?? []
                    )
                    .padding(.horizontal)
                    .frame(height: 120)
                }
                
                VStack(alignment: .leading) {
                    title("Stared")
                    PatternGridListView(
                        style: .grid,
                        presented: $presented,
                        patternURLs: store.urlsByCategory[.conduit] ?? []
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
    
    private func title(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .padding([.leading, .top])
    }
}

extension PatternGridListView {
    enum Style {
        case grid
        case horizontal
    }
}

struct PatternGridListView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var boardStore: BoardStore
    @EnvironmentObject var authentication: Authentication
    
    var style: Style
    @Binding var presented: Bool
    var patternURLs: [URL]
    
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
                        PatterndGridLoadView(
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
            PatterndGridLoadView(
                url: url,
                isSignIn: authentication.isSignIn,
                didTap: didTapItem,
                didToggleStar: didToggleStar
            )
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

struct PatterndGridLoadView: View {
    @StateObject private var loader: PatternLoader
    private var isSignIn: Bool
    private var didTap: (BoardItem) -> Void
    private var didToggleStar: (BoardItem) -> Void

    @State private var isPresentedAlertNeedLogin = false

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
            PatternGridView(board: board)
                .onTapGesture {
                    didTap(board)
                }
                .contextMenu {
                    BoardSelectContextMenu(
                        isStared: .init(get: { board.stared },
                                        set: { didSetStared(value: $0, board: board) })
                    )
                }
                .alert(isPresented: $isPresentedAlertNeedLogin) {
                    Alert(title: Text("Need login."))
                }
        } else {
            PatternGridView.placeHolder()
        }
    }
    
    // MARK: Action
    
    private func didSetStared(value: Bool, board: BoardItem) {
        if isSignIn {
            withAnimation {
                didToggleStar(board)
                loader.refresh()
            }
        } else {
            self.isPresentedAlertNeedLogin.toggle()
        }
    }
}

struct PatternGridView: View {
    let board: BoardItem
    
    static func placeHolder() -> some View {
        PatternGridView(
            board: BoardItem(boardDocumentID: "",
                             title: BoardPreset.nebura.displayText,
                             board: BoardPreset.nebura.board.board,
                             stared: false)
        )
        .redacted(reason: .placeholder)
    }
    
    var body: some View {
        VStack {
            HStack {
                BoardThumbnailImage(board: board.board, cacheKey: board.id)
                Spacer()
            }
            HStack {
                Text(board.title) // TODO: 画像サイズの横幅に一致させるようにしたい
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
    }
}

struct PatterndGridView_Previews: PreviewProvider {
    static var previews: some View {
        PatterndGridLoadView(url: URL(string: "https://lifegame-dev.web.app/pattern/$rats.json")!,
                         isSignIn: true,
                         didTap: { _ in },
                         didToggleStar: { _ in })
    }
}
