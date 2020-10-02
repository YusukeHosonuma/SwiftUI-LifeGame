//
//  PatternSelectWindow.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/24.
//

import SwiftUI
import LifeGame

struct PatternSelectWindow: View {
    
    // MARK: Environments
    
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var gameManager: GameManager
 
    // MARK: Local
    
    @StateObject var patternSelectManager: PatternSelectManager
    @State var selectionItem: String? = "All"

    init(dismiss: @escaping () -> Void) {
        _patternSelectManager = StateObject(wrappedValue: .init(presented: .init(get: { true }, set: { _ in dismiss() })))
    }
    
    // MARK: Views
    
    var patternURLs: [URL] {
        guard let item = selectionItem else { return [] }
        
        if let category = PatternCategory(rawValue: item) {
            return patternSelectManager.urlsByCategory[category] ?? []
        } else {
            return patternSelectManager.allURLs
        }
    }

    var navigationItmes: [String] {
        ["All"] + PatternCategory.allCases.map(\.rawValue)
    }
    
    var body: some View {
        NavigationView {
            List(selection: $selectionItem) {
                
                // TODO: 現時点ではスターによるフィルタリングは機能していないので、そのうち実装する。
                Section(header: Text("Search options")) {
                    Toggle("Star only", isOn: $setting.isFilterByStared.animation())
                        .enabled(authentication.isSignIn)
                }

                // Note:
                // - 初期表示時に選択されている"All"がきれいにハイライトされない。（macOS beta 9）
                // - Cmd + Click などで未選択状態にできてしまう。
                Section {
                    ForEach(navigationItmes, id: \.self) { name in
                        Text(name).tag(name)
                    }
                }
            }
            .listStyle(SidebarListStyle())
            
            VStack {
                Text("Select board")
                    .font(.title)
                    .padding()
                
                PatternGridListView(
                    style: .grid,
                    patternURLs: patternURLs,
                    didTapItem: didTapItem,
                    didToggleStar: didToggleStar
                )
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: patternSelectManager.cancel)
            }
        }
    }
    
    // MARK: Action
    
    private func didTapItem(item: PatternItem) {
        patternSelectManager.select(item: item)
    }
    
    private func didToggleStar(item: PatternItem) {
        patternSelectManager.toggleStar(item: item)
    }
}

struct BoardListView_Previews: PreviewProvider {
    static var previews: some View {
        PatternSelectWindow(dismiss: {})
    }
}