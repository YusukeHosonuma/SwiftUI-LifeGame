//
//  BoardSelectStyle.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/10.
//

enum BoardSelectStyle {
    case grid
    case list
    
    mutating func toggle() {
        switch self {
        case .grid:
            self = .list
            
        case .list:
            self = .grid
        }
    }
    
    var imageName: String {
        switch self {
        case .grid:
            return "list.bullet"

        case .list:
            return "square.grid.2x2.fill"
        }
    }
}
