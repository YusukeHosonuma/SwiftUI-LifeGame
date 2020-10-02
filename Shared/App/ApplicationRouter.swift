//
//  ApplicationRouter.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/09/19.
//

import Foundation
import Combine

final class ApplicationRouter: ObservableObject {
    static let shared = ApplicationRouter()

    @Published var didOpenPatteenURL: URL?
    
    private var cancellables: [AnyCancellable] = []
    
    private init() {}

    func performURL(url: URL) {
        let patternID = url.lastPathComponent
        guard patternID != "0" else { return }
        
        didOpenPatteenURL = Web.patternJSONURL(patternID: patternID)
    }
}
