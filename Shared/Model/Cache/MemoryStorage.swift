//
//  MemoryStorage.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/12.
//

import Foundation
import UIKit

final class ThumbnailImageCacheStorage {
    static var shared = ThumbnailImageCacheStorage()
    
    private let cache = NSCache<NSString, UIImage>()
    
    func store(key: String, image: UIImage) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func value(forKey key: String) -> UIImage? {
        guard let value = cache.object(forKey: key as NSString) else { return nil }
        return value
    }
}
