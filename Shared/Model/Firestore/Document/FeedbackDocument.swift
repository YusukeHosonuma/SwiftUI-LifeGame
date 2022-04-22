//
//  FeedbackDocument.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

enum FeedbackCategory: String, CaseIterable, Identifiable, Codable {
    case proposal = "Proposal"
    case bug = "Bug"
    case other = "Other"
    
    var id: String { rawValue }
    var description: String { rawValue }
}

struct FeedbackDocument: Codable {

    @DocumentID var id: String!
    @ServerTimestamp var createdAt: Date?
    var reference: DocumentReference!

    var title: String
    var content: String
    var category: FeedbackCategory
    var senderUserID: String
    
    init(title: String, content: String, category: FeedbackCategory, senderUserID: String) {
        self.title = title
        self.content = content
        self.category = category
        self.senderUserID = senderUserID
    }
}

extension FeedbackDocument {
    init(snapshot: DocumentSnapshot) {
        var document = try! snapshot.data(as: Self.self)
        document.reference = snapshot.reference
        self = document
    }
}
