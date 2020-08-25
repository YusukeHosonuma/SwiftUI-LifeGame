//
//  FeedbackManager.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/23.
//

import SwiftUI

final class FeedbackManager: ObservableObject {
    
    static let limitDescriptionCount = 400
    
    @Published var title = ""
    @Published var content = ""
    @Published var selectedCategory = FeedbackCategory.proposal
    
    private let feedbackRepoisotry: FirestoreFeedbackRepository = .shared
    private let userID: String
    
    init(userID: String) {
        self.userID = userID
    }
    
    func isValid() -> Bool {
        !title.isEmpty && !content.isEmpty
    }
    
    func send() {
        let document = FeedbackDocument(title: title,
                                        content: content,
                                        category: selectedCategory,
                                        senderUserID: userID)
        feedbackRepoisotry.add(document)
    }
}
