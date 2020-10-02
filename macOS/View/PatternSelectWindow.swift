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
        _patternSelectManager = .init(wrappedValue: .init(dismiss: dismiss))
    }
    
    // MARK: Views
    
    var patternURLs: [URL] {
        guard let item = selectionItem else { return [] }
        
        let urls: [(URL, Bool)]
        
        if let category = PatternCategory(rawValue: item) {
            urls = patternSelectManager.urlsByCategory[category] ?? []
        } else {
            urls = patternSelectManager.allURLs
        }
        
        return setting.isFilterByStared
            ? urls.filter(\.1).map(\.0)
            : urls.map(\.0)
    }
    
    var body: some View {
        NavigationView {
            List(selection: $selectionItem) {
                
                // TODO: 現時点ではスターによるフィルタリングは機能していないので、そのうち実装する。
                Section(header: Text("Search options")) {
                    Toggle("Star only", isOn: $setting.isFilterByStared.animation())
                        .enabled(authentication.isSignIn)
                }
                
                Section(header: Text("General")) {
                    Text("All").tag("All")
                }

                // Note:
                // - 初期表示時に選択されている"All"がきれいにハイライトされない。（macOS beta 9）
                // - Cmd + Click などで未選択状態にできてしまう。
                Section(header: Text("Category")) {
                    ForEach(PatternCategory.allCases.map(\.rawValue), id: \.self) { name in
                        Text(name).tag(name)
                    }
                }
            }
            .listStyle(SidebarListStyle())
            
            PatternGridListView(
                style: .grid,
                patternURLs: patternURLs,
                didTapItem: didTapItem,
                didToggleStar: didToggleStar
            )
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
