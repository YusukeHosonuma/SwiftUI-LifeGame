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
    
    init(url: URL) {
        let patternPublisher = URLSession.shared
            .dataTaskPublisher(for: url)
            .map { (data, response) -> Data in
                data
            }
            .decode(type: LifeWikiPattern.self, decoder: JSONDecoder())
        
        let staredIdsPublisher = FirestoreStaredRepository(user: Auth.auth().currentUser!)
            .all()
            .map { Set($0.map(\.id)) }
            .setFailureType(to: Error.self)
        
        Publishers.Zip(patternPublisher, staredIdsPublisher)
            .map { pattern, staredIds in
                BoardItem(boardDocumentID: "",
                          title: pattern.title,
                          board: pattern.makeBoard(),
                          stared: staredIds.contains(pattern.id))
            }
            .replaceError(with: nil)
            .assign(to: &$board)
    }
}

struct AllPatternView: View {
    @State var ids: [String] = []
    
    var body: some View {
        ForEach(ids, id: \.self) { id in
            
        }
        Text("")
            .onReceive(PatternService.shared.allPatternIds()) {
                ids = $0
            }
    }
}

struct PatterndGridView: View {
    @StateObject var loader: PatternLoader
    
    init(url: URL) {
        _loader = StateObject(wrappedValue: PatternLoader(url: url))
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
        } else {
            ProgressView()
        }
    }
}

struct PatterndGridView_Previews: PreviewProvider {
    static var previews: some View {
        PatterndGridView(url: URL(string: "https://lifegame-dev.web.app/pattern/$rats.json")!)
    }
}
