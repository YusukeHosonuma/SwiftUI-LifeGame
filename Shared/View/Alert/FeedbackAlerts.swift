//
//  FeedbackAlerts.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/25.
//

import SwiftUI

enum FeedbackAlertType {
    case invalid
    case sendConfirm
    case thanks
}

enum FeedbackAlerts: Identifiable {
    case invalid
    case sendConfirm(action: () -> Void)
    case thanks(action: () -> Void)

    var alert: Alert {
        switch self {
        case .invalid:
            return Alert(title: Text("Please input title and description."))
            
        case let .sendConfirm(action):
            return Alert(title: Text("Send feedback?"),
                         primaryButton: .default(Text("Send"), action: action),
                         secondaryButton: .cancel())
            
        case let .thanks(action):
            return Alert(title: Text("Thanks for feedback!"),
                         dismissButton: .default(Text("OK"), action: action))
        }
    }

    // TODO: なんかいいやり方あったっけ？
    var id: Int {
        switch self {
        case .invalid:        return 0
        case .sendConfirm(_): return 1
        case .thanks(_):      return 2
        }
    }
}
