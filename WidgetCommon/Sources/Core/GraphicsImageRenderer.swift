//
//  GraphicsImageRenderer.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/13.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public final class GraphicsImageRenderer {
    private let size: CGSize
    
    public init(size: CGSize) {
        self.size = size
    }
    
    #if os(macOS)
    func image(actions: (CGContext) -> ()) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocusFlipped(true)
        actions(NSGraphicsContext.current!.cgContext)
        image.unlockFocus()
        return image
    }
    #else
    func image(actions: @escaping (CGContext) -> ()) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { context in
            actions(context.cgContext)
        }
    }
    #endif
}
