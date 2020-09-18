//
//  PatternStore.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import Combine
import Foundation

final class PatternStore: ObservableObject {
    @Published var allURLs: [URL] = []
    @Published var staredURLs: [URL] = []
    @Published var historyURLs: [URL] = []
    @Published var urlsByCategory: [PatternCategory: [URL]] = [:]

    private let patternService: PatternService = .shared
    private var cancellables: [AnyCancellable] = []
    
    init() {
        patternService.patternURLs().assign(to: &$allURLs)
        patternService.listenStaredPatternURLs().assign(to: &$staredURLs)
        patternService.listenHistoryPatternURLs().assign(to: &$historyURLs)
        
        for category in PatternCategory.allCases {
            patternService
                .patternURLs(by: category.rawValue)
                .sink { urls in
                    self.urlsByCategory[category] = urls
                }
                .store(in: &cancellables)
        }
    }
    
    func recordHistory(patternID: String) {
        patternService.recordHistory(patternID: patternID)
    }
    
    func toggleStar(item: PatternItem) {
        patternService.toggleStar(item: item)
    }
}
