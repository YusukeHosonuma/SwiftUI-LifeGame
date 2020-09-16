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
    
    func getAllPatternReferences() -> AnyPublisher<[DocumentReference], Never> {
        PatternIDRepository.shared.all
            .map { $0.patternReferences }
            .eraseToAnyPublisher()
    }
    
    func allPatternIds() -> AnyPublisher<[String], Never> {
        PatternIDRepository.shared.all
            .map { document in
                document.patternReferences.map {
                    String($0.path.split(separator: "/").last!)
                }
            }
            .eraseToAnyPublisher()
    }
}
