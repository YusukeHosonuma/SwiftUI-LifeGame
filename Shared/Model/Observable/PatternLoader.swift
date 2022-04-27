//
//  PatternLoader.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import SwiftUI
import Combine
import Core

final class PatternLoader: ObservableObject {
    @Published var board: PatternItem?
    
    private let url: URL
    private let patternService: PatternService = .shared
    private var cancellables: [AnyCancellable] = []
    
    init(url: URL) {
        self.url = url
        refresh()
    }
    
    func refresh() {
        patternService.fetch(from: url).assign(to: &$board)
    }
}
