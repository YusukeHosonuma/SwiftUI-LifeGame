//
//  PatternStore.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import SwiftUI
import Combine
import Foundation

final class PatternSelectManager: ObservableObject {
    @Published var allURLs: [URL] = []
    @Published var staredURLs: [URL] = []
    @Published var historyURLs: [URL] = []
    @Published var urlsByCategory: [PatternCategory: [URL]] = [:]

    private let authentication: Authentication = .shared
    private let patternService: PatternService = .shared
    private let gameManager: GameManager = .shared
    private var cancellables: [AnyCancellable] = []
    private var presented: Binding<Bool>
    
    init(presented: Binding<Bool>) {
        self.presented = presented
        authentication.$isSignIn
            .sink { [weak self] _ in
                self?.bind()
            }
            .store(in: &cancellables)
    }
    
    func toggleStar(item: PatternItem) {
        patternService.toggleStar(item: item)
    }

    func select(item: PatternItem) {
        gameManager.setPattern(item)
        presented.wrappedValue = false
    }
    
    func cancel() {
        presented.wrappedValue = false
    }
    
    // MARK: Private

    private func bind() {
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
}
