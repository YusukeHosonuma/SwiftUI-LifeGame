//
//  FeedbackAlerts.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/25.
//

import SwiftUI

enum FeedbackAlert: Int, Identifiable {
    case invalid
    case sendConfirm
    case thanks
    
    var id: Int { rawValue }
    
    static func invalidAlert() -> Alert {
        Alert(title: Text("Please input title and description."))
    }
    
    static func sendConfirmAlert(tapSend: @escaping () -> Void) -> Alert {
        Alert(
            title: Text("Send feedback?"),
            primaryButton: .default(Text("Send"), action: tapSend),
            secondaryButton: .cancel()
        )
    }
    
    static func thanksAlert(tapOK: @escaping () -> Void) -> Alert {
        Alert(
            title: Text("Thanks for feedback!"),
            dismissButton: .default(Text("OK"), action: tapOK)
        )
    }
}
