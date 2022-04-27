//
//  Web.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

import Foundation

public enum Web {
    public static func patternJSONURL(patternID: String) -> URL {
        URL(string: "https://lifegame-dev.web.app/pattern/\(patternID).json")!
    }
}
