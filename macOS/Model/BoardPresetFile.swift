//
//  BoardPresetFile.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/10.
//

import Foundation
import LifeGame

struct BoardPresetFile: Codable {
    var title: String
    var size: Int
    var cells: [Int]
}

//extension BoardPresetFile {
//    init(document: BoardDocument) {
//        title = document.title
//        size = document.size
//        cells = document.cells
//    }
//}
