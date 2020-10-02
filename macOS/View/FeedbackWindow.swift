//
//  MacFeedbackView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/25.
//

import SwiftUI

struct FeedbackWindow: View {
    
    // MARK: Inputs
    
    @StateObject private var feedbackManager: FeedbackManager
    private let dismiss: () -> Void
    
    // MARK: Local
    
    @State private var isPresentedAlertConfirm = false
    @State private var presentedAlert: FeedbackAlert?

    // MARK: Initializer
    
    init(dismiss: @escaping () -> Void, userID: String) {
        self.dismiss = dismiss
        _feedbackManager = StateObject(wrappedValue: FeedbackManager(userID: userID))
    }
    
    // MARK: View
    
    var body: some View {
        VStack(alignment: .leading) {
            sectionGroup(title: "Basic Information") {
                itemGroup(description: "Title:") {
                    TextField("Example: It crashed when I tapped the button.",
                              text: $feedbackManager.title)
                }
                
                itemGroup(description: "Type:") {
                    Picker(selection: $feedbackManager.selectedCategory, label: EmptyView()) {
                        ForEach(FeedbackCategory.allCases) {
                            Text($0.description).tag($0)
                        }
                    }
                }
            }

            sectionGroup(title: "Description") {
                itemGroup(description: "Please fill in freely:") {
                    AppTextEditor(
                        text: $feedbackManager.content,
                        placeholder: "Please fill in freely.", // Not work in Mac
                        limit: FeedbackManager.limitDescriptionCount
                    )
                    .lineLimit(nil)
                    .frame(height: 120)
                    .border(Color.placeholderText)
                    
                    HStack {
                        Spacer()
                        Text("\(feedbackManager.content.count) / \(FeedbackManager.limitDescriptionCount)")
                            .foregroundColor(feedbackManager.content.count >= FeedbackManager.limitDescriptionCount ? .red : Color.placeholderText)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Continue") {
                    presentedAlert = .sendConfirm
                }
                .enabled(feedbackManager.isValid())
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: dismiss)
            }
        }
        .alert(item: $presentedAlert) { type in
            switch type {
            case .invalid:
                return FeedbackAlert.invalidAlert()
                
            case .sendConfirm:
                return FeedbackAlert.sendConfirmAlert(tapSend: {
                    feedbackManager.send()
                    
                    // Note:
                    // macOSでAlertを連続で表示しようとしてもうまく行かない。（macOS-beta 9）❗
                    //
                    // ```
                    // dismissAlert() // 事前にdismissしてもしなくてもNG
                    // presentedAlert = .thanks
                    // ```
                    //
                    // そのためとりあえずフィードバック画面を閉じるだけに留める。
                    dismissAlert()
                    dismiss()
                })

            case .thanks:
                return FeedbackAlert.thanksAlert {
                    dismiss()
                }
            }
        }
        .padding()
    }
    
    func itemGroup<T: View>(description: String, @ViewBuilder content: () -> T) -> some View {
        VStack(alignment: .leading) {
            Text(description)
            content()
        }
        .padding(.bottom)
    }
    
    func sectionGroup<T: View>(title: String, @ViewBuilder content: () -> T) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .foregroundColor(.accentColor)
                .padding(.bottom, 4)
            content()
        }
    }
    
    // MARK: Action
    
    private func dismissAlert() {
        self.presentedAlert = nil
    }

}

//struct MacFeedbackView_Previews: PreviewProvider {
//    static var previews: some View {
//        MacFeedbackView()
//    }
//}
