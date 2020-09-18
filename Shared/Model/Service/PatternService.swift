//
//  PatternService.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/12.
//

import Foundation
import Combine
import FirebaseFirestore

final class PatternService {
    static let shared = PatternService()

    private let authentication: Authentication = .shared

    func patternURLs() -> AnyPublisher<[URL], Never> {
        PatternIDRepository.shared.all
            .map { document in
                document.data.map(\.jsonURL)
            }
            .eraseToAnyPublisher()
    }
    
    func patternURLs(by type: String) -> AnyPublisher<[URL], Never> {
        PatternIDRepository.shared.all
            .map { document in
                document.data.filter { $0.patternType == type }.map(\.jsonURL)
            }
            .eraseToAnyPublisher()
    }
    
    func listenStaredPatternURLs() -> AnyPublisher<[URL], Never> {
        guard let staredRepository = authentication.repositories?.stared else {
            return Just([]).eraseToAnyPublisher()
        }
            
        return staredRepository
            .publisher
            .map { $0.map(\.jsonURL) }
            .eraseToAnyPublisher()
    }

    func listenHistoryPatternURLs() -> AnyPublisher<[URL], Never> {
        guard let historyRepository = authentication.repositories?.history else {
            return Just([]).eraseToAnyPublisher()
        }
        
        return historyRepository
            .publisher
            .map { $0.map(\.jsonURL) }
            .eraseToAnyPublisher()
    }
    
    func fetch(from url: URL) -> AnyPublisher<BoardItem?, Never> {
        let patternPublisher = URLSession.shared
            .dataTaskPublisher(for: url)
            .retry(3)
            .map { (data, response) -> Data in
                data
            }
            .decode(type: LifeWikiPattern.self, decoder: JSONDecoder())

        return Publishers.Zip(patternPublisher, staredPatternIDs().setFailureType(to: Error.self))
            .map { pattern, staredIds in
                BoardItem(boardDocumentID: pattern.id,
                          title: pattern.title,
                          board: pattern.makeBoard(),
                          stared: staredIds.contains(pattern.id))
            }
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private func staredPatternIDs() -> AnyPublisher<[String], Never> {
        guard let staredRepository = authentication.repositories?.stared else {
            return Just([]).eraseToAnyPublisher()
        }
        
        return staredRepository // TODO: たぶん登録順でソートさせたくなるはず（あるいはタイトル？）
            .all()
            .map { $0.map(\.patternID) }
            .eraseToAnyPublisher()
    }
}
