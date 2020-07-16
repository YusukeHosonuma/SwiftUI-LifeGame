//
//  Collection+.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/16.
//

extension Collection {
    func withIndex() -> [(Int, Element)] {
        Array(zip(0..<self.count, self))
    }
}
