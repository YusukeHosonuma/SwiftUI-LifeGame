//
//  PatternStore.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import SwiftUI
import Combine
import Foundation
import Core

final class PatternSelectManager: ObservableObject {
    typealias Handler = () -> Void
    
    @Published var allURLs: [PatternURL] = []
    @Published var staredURLs: [URL] = []
    @Published var historyURLs: [URL] = []
    @Published var urlsByCategory: [PatternCategory: [PatternURL]] = [:]

    private let authentication: Authentication = .shared
    private let patternService: PatternService = .shared
    private let gameManager: GameManager = .shared
    private var cancellables: [AnyCancellable] = []
    private var dismiss: Handler?
    
    init(dismiss: Handler? = nil) {
        self.dismiss = dismiss
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
        dismiss?()
    }
    
    func cancel() {
        dismiss?()
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
