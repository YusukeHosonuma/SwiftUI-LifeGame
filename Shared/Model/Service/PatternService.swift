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

    private let patternIDRepository: PatternIDRepository = .shared
    private let authentication: Authentication = .shared
    
    func patternURLs(by type: String? = nil) -> AnyPublisher<[URL], Never> {
        patternIDRepository
            .all
            .map { document in
                if let type = type {
                    return document.data.filter { $0.patternType == type }.map(\.jsonURL)
                } else {
                    return document.data.map(\.jsonURL)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetch(from url: URL) -> AnyPublisher<PatternItem?, Never> {
        let patternPublisher = URLSession.shared
            .dataTaskPublisher(for: url)
            .retry(3)
            .map { (data, response) -> Data in
                data
            }
            .decode(type: LifeWikiPattern.self, decoder: JSONDecoder())

        return Publishers.Zip(patternPublisher, staredPatternIDs().setFailureType(to: Error.self))
            .map { pattern, staredIds in
                PatternItem(
                    patternID: pattern.id,
                    title: pattern.title,
                    board: pattern.makeBoard(),
                    stared: staredIds.contains(pattern.id)
                )
            }
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Star
    
    func listenStaredPatternURLs() -> AnyPublisher<[URL], Never> {
        guard let staredRepository = authentication.repositories?.stared else {
            return Just([]).eraseToAnyPublisher()
        }
            
        return staredRepository
            .publisher
            .map { $0.map(\.jsonURL) }
            .eraseToAnyPublisher()
    }
    
    func toggleStar(item: PatternItem) {
        guard let staredRepository = authentication.repositories?.stared else { return }
        if item.stared {
            staredRepository.setData(StaredDocument(patternID: item.patternID))
        } else {
            staredRepository.delete(by: item.patternID)
        }
    }

    // MARK: - History
    
    func recordHistory(patternID: String) {
        guard let historyRepository = authentication.repositories?.history else { return }
        historyRepository.setData(by: patternID, document: HistoryDocument())
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
