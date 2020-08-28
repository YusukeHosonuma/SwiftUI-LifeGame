//
//  FeedbackView.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/23.
//

import SwiftUI

struct FeedbackView: View {
    @StateObject private var feedbackManager: FeedbackManager
    @Binding private var isPresented: Bool
    @State private var presentedAlert: FeedbackAlert?

    init(isPresented: Binding<Bool>, userID: String) {
        _isPresented = isPresented
        _feedbackManager = StateObject(wrappedValue: FeedbackManager(userID: userID)) // ✅ Experimental
    }

    var body: some View {
        NavigationView {
            ScrollViewReader { scroll in
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
                            Text("\(feedbackManager.content.count) / \(FeedbackManager.limitDescriptionCount)")
                                .foregroundColor(feedbackManager.content.count >= FeedbackManager.limitDescriptionCount ? .red : nil)
                        },
                        footer: Text("Please enter less than \(FeedbackManager.limitDescriptionCount) characters.")
                    ) {
                        // Note:
                        // 現状、iPhone SE だとキーボード表示時にテキストエディタが隠れてしまう問題がある。（beta 6）❗
                        // （ただし、スクロールすればいいだけなので大した問題ではない）
                        AppTextEditor(
                            text: $feedbackManager.content,
                            placeholder: "Please fill in freely.", // Not work in Mac
                            limit: FeedbackManager.limitDescriptionCount
                        )
                        // Note:
                        // `focusable`というモディファイアが以前はあったようだが現在は見つけられない。（beta 6）❗
                        // https://developer.apple.com/documentation/swiftui/button/focusable(_:onfocuschange:)
                        .onTapGesture {
                            // Note:
                            // `.sheet`で表示されたViewの場合に`scrollTo`が機能しない（beta 6）❗
                            scroll.scrollTo(42, anchor: .bottom)
                        }
                        .lineLimit(nil)
                        .frame(height: 100)
                        .id(42)
                    }
                }
                .alert(item: $presentedAlert, content: showAlert)
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
    }
    
    // MARK: Alert

    private func showAlert(type: FeedbackAlert) -> Alert {
        switch type {
        case .invalid:
            return FeedbackAlert.invalidAlert()
            
        case .sendConfirm:
            return FeedbackAlert.sendConfirmAlert(tapSend: {
                feedbackManager.send()
                presentedAlert = .thanks
            })

        case .thanks:
            return FeedbackAlert.thanksAlert(tapOK: {
                isPresented = false
            })
        }
    }

    // MARK: Action
    
    private func tapCancelButton() {
        isPresented = false
    }
    
    // TODO: テストしやすくするなら、このあたりも`FeedbackManager`に移したほうがよいかも。
    private func tapSendToolbarButton() {
        guard feedbackManager.isValid() else {
            presentedAlert = .invalid
            return
        }
        presentedAlert = .sendConfirm
    }
}


struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView(isPresented: .constant(true), userID: "")
    }
}
