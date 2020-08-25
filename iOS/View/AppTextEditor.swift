//
//  AppTextEditor.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/23.
//

import SwiftUI

// ref: https://lostmoa.com/blog/AddPlaceholderTextToSwiftUITextEditor/

/// Please call below before uses.
/// ```
/// UITextView.appearance().backgroundColor = .clear
/// ```
struct AppTextEditor: View {
    @Binding private var text: String
    private var placeholder: String // TODO: Macではプレースホルダは機能しない
    private var limit: Int?
    
    init(text: Binding<String>, placeholder: String, limit: Int? = nil) {
        _text = text
        self.placeholder = placeholder
        self.limit = limit
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .allowsHitTesting(false)
                    .foregroundColor(.placeholderText)
                    .padding(.horizontal, 2)
                    .padding(.vertical, 8)
            }
            TextEditor(text: $text)
                .onChange(of: text) { string in
                    if let limit = limit, string.count > limit {
                        text = String(string.prefix(limit))
                    }
                }
        }
    }
}

struct AppTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        AppTextEditor(text: .constant(""), placeholder: "placeholder")
    }
}
