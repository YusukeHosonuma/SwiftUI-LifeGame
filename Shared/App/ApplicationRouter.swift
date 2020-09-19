//
//  ApplicationRouter.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/09/19.
//

import Foundation
import Combine

final class ApplicationRouter {
    static let shared = ApplicationRouter()
    
    private var cancellables: [AnyCancellable] = []
    
    private init() {}

    func performURL(url: URL) {
        let patternID = url.lastPathComponent
        guard patternID != "0" else { return }
        
        // Note:
        // 賛否はあるかもだが、何も尋ねずに現状の盤面を上書きしてしまう仕様にする。
        
        PatternService.shared.fetch(from: Web.patternJSONURL(patternID: patternID))
            .compactMap { $0 }
            .sink { item in
                BoardManager.shared.setBoard(board: item.board)
            }
            .store(in: &cancellables)
    }
}
