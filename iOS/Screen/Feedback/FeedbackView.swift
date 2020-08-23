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
    @State private var isPresentedInvalidAlert = false
    @State private var isPresentedSendConfirmAlert = false
    @State private var isPresentedSentAlert = false

    init(isPresented: Binding<Bool>, userID: String) {
        _isPresented = isPresented
        _feedbackManager = StateObject(wrappedValue: FeedbackManager(userID: userID)) // TODO: ✅ やや実験的
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Type")) {
                    Picker("What type of feedback?", selection: $feedbackManager.selectedCategory) {
                        ForEach(FeedbackCategory.allCases) { Text($0.description).tag($0) }
                    }
                }
                .alert(isPresented: $isPresentedInvalidAlert) {
                    Alert(title: Text("Please input title and description."))
                }
                
                Section(header: Text("Title")) {
                    TextField("Example: It crashed when I tapped the button.", text: $feedbackManager.title)
                }
                .alert(isPresented: $isPresentedSentAlert) {
                    Alert(title: Text("Thanks for feedback!"),
                          dismissButton: .default(Text("OK")) { isPresented = false })
                }
                
                Section(
                    header: HStack {
                        Text("Description")
                        Spacer()
                        Text("\(feedbackManager.content.count) / \(LimitDescriptionCount)")
                            .foregroundColor(feedbackManager.content.count == LimitDescriptionCount ? .red : nil)
                    },
                    footer: Text("Please enter less than \(LimitDescriptionCount) characters.")) {
                    AppTextEditor(text: $feedbackManager.content, placeholder: "Please fill in freely.", limit: LimitDescriptionCount)
                        .lineLimit(nil)
                        .frame(height: 100)
                }

            }
            // Note:
            // `.alert()`をチェーンさせるような書き方はできないらしい。（おそらく元のViewが存在しないとNG）
            // また`ToolbarItem`内の`Button`に`.alert()`してもダメらしい。（beta5）❗
            .alert(isPresented: $isPresentedSendConfirmAlert) {
                Alert(title: Text("Send feedback?"),
                      primaryButton: .default(Text("Send"), action: tapSendAlertButton),
                      secondaryButton: .cancel())
            }
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
    
    // MARK: Action
    
    private func tapCancelButton() {
        isPresented = false
    }
    
    // TODO: テストしやすくするなら、このあたりも`FeedbackManager`に移したほうがよいかも。
    private func tapSendToolbarButton() {
        guard feedbackManager.isValid() else {
            isPresentedInvalidAlert.toggle()
            return
        }
        isPresentedSendConfirmAlert.toggle()
    }

    private func tapSendAlertButton() {
        feedbackManager.send()
        isPresentedSentAlert.toggle()
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView(isPresented: .constant(true), userID: "")
    }
}
