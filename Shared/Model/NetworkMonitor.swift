//
//  NetworkMonitor.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/15.
//

import SwiftUI
import Network

final class NetworkMonitor: ObservableObject {
    @Published var status: NWPath.Status = .satisfied
    
    init() {
        NWPathMonitor()
            .publisher()
            .map(\.status)
            .assign(to: &$status)
    }

    // Note: ✅
    // @EnvironmentObject は`wrappedValue` に ObservableObject準拠を要求するため、
    // モック側でも完全に同じプロパティを要求されてしまい無駄が多いので一端以下。
    // （他に良い方法が見つかれば変更する）
    
    #if DEBUG
    init(mockStatus: NWPath.Status) {
        status = mockStatus
    }
    #endif
}
