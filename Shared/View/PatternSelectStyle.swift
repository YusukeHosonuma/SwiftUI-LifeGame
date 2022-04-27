//
//  BoardSelectStyle.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/10.
//

// TODO: 現在、画面上では利用されていないので、どうするか考える。

import Core

enum PatternSelectStyle: Int, CaseIterable {
    case grid
    case list
}

extension PatternSelectStyle {
    var text: String {
        switch self {
        case .grid: return "Grid"
        case .list: return "List"
        }
    }
    
    var imageName: String {
        switch self {
        case .grid: return "list.bullet"
        case .list: return "square.grid.2x2.fill"
        }
    }
}

extension PatternSelectStyle: UserDefaultConvertible {
    init?(with object: Any) {
        guard let rawValue = object as? Int, let value = PatternSelectStyle(rawValue: rawValue) else { return nil }
        self = value
    }
    
    func object() -> Any? {
        self.rawValue
    }
}
