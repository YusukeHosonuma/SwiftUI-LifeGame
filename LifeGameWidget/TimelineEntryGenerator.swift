//
//  EntryGenerator.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/12.
//

import Foundation
import Combine
import WidgetKit
import FirebaseAuth
import FirebaseFirestore

final class TimelineEntryGenerator {
    static let shared = TimelineEntryGenerator()
    
    private var cancellables: [AnyCancellable] = []
    
    func generate(for family: WidgetFamily, times: Int, staredOnly: Bool, completion: @escaping ([Entry]) -> Void) {
        let displayCount = family.displayCount
        
        candidatePatternReferences(staredOnly: staredOnly)
            .flatMap { references in
                Publishers.MergeMany(
                    references
                        .shuffled()
                        .prefix(displayCount * times)
                        .map { reference in
                            FirestorePatternRepository.shared.get(by: reference)
                        }
                )
            }
            .collect()
            .sink { documents in
                let entries = self.generateEntries(from: documents, displayCount: displayCount, times: times)
                completion(entries)
            }
            .store(in: &cancellables)
    }
    
    // MARK: Private
    
    private func generateEntries(from documents: [PatternDocument], displayCount: Int, times: Int) -> [Entry] {
        let currentDate = Date()

        let entries: [Entry] = documents
            .group(by: displayCount)
            .prefix(times)
            .enumerated()
            .map { offset, documents in
                let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
                
                let data = documents.map { document in
                    BoardData(title: document.title,
                              board: document.makeBoard(),
                              url: URL(string: "board:///\(document.id)")!,
                              cacheKey: document.id)
                }
                
                return Entry(date: entryDate, relevance: data)
            }
        return entries
    }
    
    private func candidatePatternReferences(staredOnly: Bool) -> AnyPublisher<[DocumentReference], Never> {
        if let user = Auth.auth().currentUser, staredOnly {
            return FirestoreStaredRepository(user: user).all()
                .map { $0.map(\.referenceBoard) }
                .eraseToAnyPublisher()
        } else {
            return PatternService.shared.getAllPatternReferences()
        }
    }
}
