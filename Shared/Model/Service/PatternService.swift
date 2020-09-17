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

//    func getAllPatternReferences() -> AnyPublisher<[DocumentReference], Never> {
//        PatternIDRepository.shared.all
//            .map { $0.patternReferences }
//            .eraseToAnyPublisher()
//    }
//
//    func allPatternIds() -> AnyPublisher<[String], Never> {
//        PatternIDRepository.shared.all
//            .map { document in
//                document.patternReferences.map {
//                    String($0.path.split(separator: "/").last!)
//                }
//            }
//            .eraseToAnyPublisher()
//    }
    
    
//    func allPatternTitles() -> AnyPublisher<[String], Never> {
//        PatternIDRepository.shared.all
//            .map { document in
//                document.data.map(\.title) // TODO: IDに変更する
//            }
//            .eraseToAnyPublisher()
//    }
    
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
    
    
    func staredPatternURLs() -> AnyPublisher<[URL], Never> {
        staredPatternIDs()
            .map { ids in
                ids.map { URL(string: "https://lifegame-dev.web.app/pattern/\($0).json")! }
            }
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
