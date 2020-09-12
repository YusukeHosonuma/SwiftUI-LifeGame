//
//  EntryGenerator.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/12.
//

import Foundation
import Combine
import WidgetKit

final class TimelineEntryGenerator {
    static let shared = TimelineEntryGenerator()
    
    private var cancellables: [AnyCancellable] = []

    func generate(for family: WidgetFamily, times: Int, completion: @escaping ([Entry]) -> Void) {
        let displayCount = family.displayCount
        
        PatternService.shared.getAllPatternReferences()
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
                let currentDate = Date()

                let entries: [Entry] = documents
                    .group(by: displayCount)
                    .prefix(times)
                    .enumerated()
                    .map { hourOffset, documents in
                        let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
                        
                        let data = documents.map { document in
                            BoardData(title: document.title,
                                      board: document.makeBoard(),
                                      url: URL(string: "board:///\(document.id)")!,
                                      cacheKey: document.id)
                        }
                        
                        return Entry(date: entryDate, relevance: data)
                    }
                completion(entries)
            }
            .store(in: &cancellables)
    }
}
