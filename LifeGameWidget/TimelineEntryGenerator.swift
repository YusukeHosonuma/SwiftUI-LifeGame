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
    
    private let patternService: PatternService = .shared
    private var cancellables: [AnyCancellable] = []
    
    func generate(for family: WidgetFamily, times: Int, staredOnly: Bool, completion: @escaping ([Entry]) -> Void) {
        let displayCount = family.displayCount
        let totalCount = displayCount * times
        
        candidatePatternURLs(staredOnly: staredOnly)
            .map { $0.shuffled().prefix(totalCount) }
            .flatMap { urls in
                Publishers.MergeMany(
                    urls.map { self.patternService.fetch(from: $0) }
                )
            }
            .collect()
            .map { $0.compactMap { $0 } }
            .sink { item in
                let entries = self.generateEntries(from: item, displayCount: displayCount, times: times)
                completion(entries)
            }
            .store(in: &cancellables)
    }
    
    // MARK: Private
    
    private func generateEntries(from items: [PatternItem], displayCount: Int, times: Int) -> [Entry] {
        let currentDate = Date()

        let entries: [Entry] = items
            .group(by: displayCount)
            .prefix(times)
            .enumerated()
            .map { offset, items in
                let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
                
                let data = items.map(BoardData.init)
                return Entry(date: entryDate, relevance: data)
            }
        return entries
    }
    
    private func candidatePatternURLs(staredOnly: Bool) -> AnyPublisher<[URL], Never> {
        return staredOnly
            ? patternService.staredPatternURLs()
            : patternService.patternURLs()
    }
}
