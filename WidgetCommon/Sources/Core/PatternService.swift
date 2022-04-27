//
//  PatternService.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/12.
//

import Foundation
import Combine
import FirebaseFirestore

// Note:
//
// This service is designed by fail-safe,
// therefore some method call is return empty (publisher) that login is neeeded.

public struct PatternURL {
    public let url: URL
    public let stared: Bool
}

final public class PatternService {
    public static let shared = PatternService()

    private let authentication: Authentication = .shared
    private let patternIDRepository: FirestorePatternIndexRepository = .shared
    private var staredRepository: FirestoreStaredRepository? { authentication.repositories?.stared }
    private var historyRepository: FirestoreHistoryRepository? { authentication.repositories?.history }
    
    public func patternURLs(by type: String? = nil) -> AnyPublisher<[PatternURL], Never> {
        patternIDRepository
            .all
            .map { document -> [URL] in
                if let type = type {
                    // TODO: カテゴリ単位でドキュメントを分けているので、そこから個別に取得したほうが高速（になるはず）
                    return document.data.filter { $0.patternType == type }.map(\.jsonURL)
                } else {
                    return document.data.map(\.jsonURL)
                }
            }
            .combineLatest(listenStaredPatternURLs())
            .map { allURLs, staredURLs in
                allURLs.map {
                    PatternURL(url: $0, stared: staredURLs.contains($0))
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func fetch(from url: URL) -> AnyPublisher<PatternItem?, Never> {
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
            .replaceError(with: nil) // TODO: エラーを投げる設計に変えたほうがいい
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Star
    
    public func staredPatternURLs(by type: String? = nil) -> AnyPublisher<[PatternURL], Never> {
        guard let staredRepository = staredRepository else {
            return Just([]).eraseToAnyPublisher()
        }

        return staredRepository
            .all()
            .map { urls in
                urls.map { PatternURL(url: $0.jsonURL, stared: true) }
            }
            .eraseToAnyPublisher()
    }
    
    public func listenStaredPatternURLs() -> AnyPublisher<[URL], Never> {
        guard let staredRepository = staredRepository else {
            return Just([]).eraseToAnyPublisher()
        }

        return staredRepository
            .publisher
            .map { $0.map(\.jsonURL) }
            .eraseToAnyPublisher()
    }
    
    public func toggleStar(item: PatternItem) {
        guard let staredRepository = staredRepository else { return }
        
        if item.stared {
            staredRepository.delete(by: item.patternID)
        } else {
            staredRepository.setData(StaredDocument(patternID: item.patternID))
        }
    }

    // MARK: - History
    
    public func recordHistory(patternID: String) {
        guard let historyRepository = historyRepository else { return }
        
        historyRepository.setData(by: patternID, document: HistoryDocument())
    }
    
    public func listenHistoryPatternURLs() -> AnyPublisher<[URL], Never> {
        guard let historyRepository = historyRepository else {
            return Just([]).eraseToAnyPublisher()
        }
        
        return historyRepository
            .publisher
            .map { $0.map(\.jsonURL) }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private func staredPatternIDs() -> AnyPublisher<[String], Never> {
        guard let staredRepository = staredRepository else {
            return Just([]).eraseToAnyPublisher()
        }
        
        return staredRepository // TODO: たぶん登録順でソートさせたくなるはず（あるいはタイトル？）
            .all()
            .map { $0.map(\.patternID) }
            .eraseToAnyPublisher()
    }
}
