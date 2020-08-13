//
//  Image+.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/13.
//

import SwiftUI

extension Image {
    #if os(macOS)
    init(image: NSImage) {
        self = Image(nsImage: image)
    }
    #else
    init(image: UIImage) {
        self = Image(uiImage: image)
    }
    #endif
}
