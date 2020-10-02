//
//  PatternDocument.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/11.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import LifeGame

struct PatternDocument: Codable, Identifiable {
    @DocumentID
    var documentID: String!
    var reference: DocumentReference!

    var title: String
    var patternType: String?
    var rule: String
    var discoveredBy: String
    var yearOfDiscovery: String
    var width: Int
    var height: Int
    var cells: [Int]
    var sourceURL: URL
    
    var id: String { documentID }
    
    enum CodingKeys: CodingKey {
        case documentID
        case title
        case patternType
        case rule
        case discoveredBy
        case yearOfDiscovery
        case width
        case height
        case cells
        case sourceURL
    }
}

// TODO: extension のデフォルト実装で提供したい
extension PatternDocument {
    init(snapshot: DocumentSnapshot) {
        var document = try! snapshot.data(as: Self.self)!
        document.reference = snapshot.reference
        self = document
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
