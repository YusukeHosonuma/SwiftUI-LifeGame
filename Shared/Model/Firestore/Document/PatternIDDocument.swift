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

extension PatternIDDocument {
    struct Data: Codable {
        var title: String
        var patternType: String
        var sourceURL: URL
    }
}

struct PatternIDDocument: Codable {
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

//struct PatternIDDocument: Codable {
//    @DocumentID
//    var documentID: String!
//    var documentReference: DocumentReference!
//
//    @ServerTimestamp
//    var updatedAt: Date?
//
//    var patternReferences: [DocumentReference]
//
//    init(patternReferences: [DocumentReference]) {
//        self.patternReferences = patternReferences
//    }
//
//    enum CodingKeys: CodingKey {
//        case documentID
//        case updatedAt
//        case patternReferences
//    }
//}

extension PatternIDDocument {
    init(snapshot: DocumentSnapshot) {
        var document = try! snapshot.data(as: Self.self)!
        //document.documentReference = snapshot.reference
        self = document
    }
}
