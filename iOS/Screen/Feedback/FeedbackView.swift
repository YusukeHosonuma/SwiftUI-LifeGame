//
//  FeedbackView.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/23.
//

import SwiftUI

private let LimitDescriptionCount = 400

struct FeedbackView: View {
    @StateObject private var feedbackManager: FeedbackManager
    @Binding private var isPresented: Bool
    @State private var presentedAlert: FeedbackAlerts?

    init(isPresented: Binding<Bool>, userID: String) {
        _isPresented = isPresented
        _feedbackManager = StateObject(wrappedValue: FeedbackManager(userID: userID)) // TODO: ✅ Experimental
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Type")) {
                    Picker("What type of feedback?", selection: $feedbackManager.selectedCategory) {
                        ForEach(FeedbackCategory.allCases) { Text($0.description).tag($0) }
                    }
                }
                Section(header: Text("Title")) {
                    TextField("Example: It crashed when I tapped the button.", text: $feedbackManager.title)
                }
                Section(
                    header: HStack {
                        Text("Description")
                        Spacer()
                        Text("\(feedbackManager.content.count) / \(LimitDescriptionCount)")
                            .foregroundColor(feedbackManager.content.count == LimitDescriptionCount ? .red : nil)
                    },
                    footer: Text("Please enter less than \(LimitDescriptionCount) characters.")
                ) {
                    AppTextEditor(text: $feedbackManager.content, placeholder: "Please fill in freely.", limit: LimitDescriptionCount)
                        .lineLimit(nil)
                        .frame(height: 100)
                }
            }
            .alert(item: $presentedAlert) { $0.alert }
            .listStyle(GroupedListStyle())
            .navigationTitle("Feedback")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: tapCancelButton)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Send", action: tapSendToolbarButton)
                }
            }
        }
    }
    
    // MARK: Alert

    private func showAlert(_ type: FeedbackAlertType) {
        let alert: FeedbackAlerts

        switch type {
        case .invalid:
            alert = .invalid
            
        case .sendConfirm:
            alert = .sendConfirm {
                feedbackManager.send()
                showAlert(.thanks)
            }
            
        case .thanks:
            alert = .thanks { isPresented = false }
        }

        self.presentedAlert = alert
    }
    
    // MARK: Action
    
    private func tapCancelButton() {
        isPresented = false
    }
    
    // TODO: テストしやすくするなら、このあたりも`FeedbackManager`に移したほうがよいかも。
    private func tapSendToolbarButton() {
        guard feedbackManager.isValid() else {
            showAlert(.invalid)
            return
        }
        showAlert(.sendConfirm)
    }
}

private enum AlertType {
    case invalid
    case sendConfirm
    case thanks
}

private enum Alerts: Identifiable {
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

    var id: Int {
        switch self {
        case .invalid:        return 0
        case .sendConfirm(_): return 1
        case .thanks(_):      return 2
        }
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView(isPresented: .constant(true), userID: "")
    }
}
