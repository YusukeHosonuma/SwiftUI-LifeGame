//
//  PatternIdentifiable.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import Foundation

protocol PatternIdentifiable {
    var patternID: String { get }
}

extension PatternIdentifiable {
    var jsonURL: URL {
        Web.patternJSONURL(patternID: patternID)
    }
}
