//
//  PatternIDDocument.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/12.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

// TODO: ✅ 以下のプロジェクトで共通利用しているソース。余力があれば共通リポジトリを作ってもよいかもしれない。
// https://github.com/YusukeHosonuma/SwiftUI-LifeGame.git
// https://github.com/YusukeHosonuma/LifeGame-DataRegister.git

extension PatternIndexDocument {
    struct Data: Codable, PatternIdentifiable {
        var patternID: String
        var title: String
        var patternType: String // TODO: 最終的には消す予定
    }
}

struct PatternIndexDocument: Codable {
    @DocumentID
    var documentID: String!

    @ServerTimestamp
    var updatedAt: Date?

    var data: [Data]
    
    init(data: [Data]) {
        self.data = data
    }
    
    enum CodingKeys: CodingKey {
        case documentID
        case updatedAt
        case data
    }
}

extension PatternIndexDocument {
    init(snapshot: DocumentSnapshot) {
        self = try! snapshot.data(as: Self.self)!
    }
}
