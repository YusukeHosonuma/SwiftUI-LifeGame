//
//  MemoryCacheStorage.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/12.
//

import Foundation

final class MemoryCacheStorage<T: AnyObject> {
    private let cache = NSCache<NSString, T>()
    
    func store(key: String, image: T) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func value(forKey key: String) -> T? {
        guard let value = cache.object(forKey: key as NSString) else { return nil }
        return value
    }
}
