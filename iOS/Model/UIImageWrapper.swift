//
//  UIImageWrapper.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/16.
//

import UIKit

struct UIImageWrapper: UserDefaultConvertible {
    var image: UIImage?
    
    init(_ image: UIImage?) {
        self.image = image
    }
    
    init?(with object: Any) {
        guard let data = object as? Data, let image = UIImage(data: data) else { return nil }
        self = UIImageWrapper(image)
    }
    
    func object() -> Any? {
        image?.pngData()
    }
}
