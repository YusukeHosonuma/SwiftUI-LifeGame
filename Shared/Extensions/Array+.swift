//
//  Array+.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/13.
//

extension Array {
    func filter(when condition: Bool, isIncluded: (Element) -> Bool) -> [Element] {
        condition ? filter(isIncluded) : self
    }
}
