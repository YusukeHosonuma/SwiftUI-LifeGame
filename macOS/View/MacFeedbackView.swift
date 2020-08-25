//
//  MacFeedbackView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/25.
//

import SwiftUI

struct MacFeedbackView: View {
    
    // MARK: Inputs
    
    @StateObject private var feedbackManager: FeedbackManager
    private let dismiss: () -> Void
    
    // MARK: Local
    
    @State private var isPresentedAlertConfirm = false
    @State private var presentedAlert: FeedbackAlerts?

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
                    
                    Text("\(feedbackManager.content.count) / \(FeedbackManager.limitDescriptionCount)")
                        .foregroundColor(feedbackManager.content.count >= FeedbackManager.limitDescriptionCount ? .red : nil)
                }
            }
            
            HStack {
                Button("Cancel", action: dismiss)
                Spacer()
                Button("Continue") {
                    showAlert(.sendConfirm)
                }
                .enabled(feedbackManager.isValid())
            }
        }
        .alert(item: $presentedAlert) { $0.alert }
        .padding()

        // Note:
        // 標準のフィードバックアシスタントのように下部のツールバーに配置したいが方法が不明。。
        // `.bottomBar`のplacementは削除されてしまったのかもしれない。（macOS-beta5）❗
        // ref: https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-toolbar-and-add-buttons-to-it
        //
        // ```
        // .toolbar {
        //     ToolbarItem(placement: .cancellationAction) {
        //         Button("Cancel") {}
        //     }
        //     ToolbarItem(placement: .primaryAction) {
        //         Button("Continue") {}
        //     }
        // }
        // ```
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
    
    // MARK: Alert
    
    // TODO: あんま見通しよくないので`MacRootView`のシートのような形式のほうがいいのかも。

    private func showAlert(_ type: FeedbackAlertType) {
        let alert: FeedbackAlerts

        switch type {
        case .invalid:
            preconditionFailure() // TODO: iOS版も.invalidを除外してしまっても良いかも
            
        case .sendConfirm:
            alert = .sendConfirm {
                feedbackManager.send()
                
                // Note:
                // macOSでAlertを連続で表示しようとしてもうまく行かない。（macOS-beta5）❗
                //
                // ```
                // dismissAlert() // 事前にdismissしてもしなくてもNG
                // showAlert(.thanks)
                // ```
                //
                // そのためとりあえずフィードバック画面を閉じるだけに留める。
                dismissAlert()
                dismiss()
            }
            
        case .thanks:
            alert = .thanks {
                dismissAlert()
                dismiss()
            }
        }

        self.presentedAlert = alert
    }
    
    private func dismissAlert() {
        self.presentedAlert = nil
    }

}

//struct MacFeedbackView_Previews: PreviewProvider {
//    static var previews: some View {
//        MacFeedbackView()
//    }
//}
