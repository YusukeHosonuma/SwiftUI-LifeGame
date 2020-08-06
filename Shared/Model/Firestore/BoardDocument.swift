//
//  BoardDocument.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/06.
//

import Foundation
import FirebaseFirestoreSwift

struct BoardDocument: Codable, Identifiable {
    @DocumentID
    var id: String?
    
    var title: String
    var size: Int
    var cells: [Int]
}
