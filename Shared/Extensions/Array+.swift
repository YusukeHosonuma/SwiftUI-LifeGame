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

    func group(by size: Int) -> [[Element]] {
        assert(size > 0)
        
        var offset: Int = 0
        var result: [[Element]] = []
        while offset < count {
            let endIndex = Swift.min(offset + size, self.count)
            result.append(Array(self[offset..<endIndex]))
            offset += size
        }
        return result
    }
}
