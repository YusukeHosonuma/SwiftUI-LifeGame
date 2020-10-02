//
//  BoardListView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/24.
//

import SwiftUI
import LifeGame

struct BoardListView: View {
    
    // MARK: Environments
    
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var gameManager: GameManager
 
    // MARK: Local
    
    @StateObject var patternSelectManager: PatternSelectManager
    @State var selectionCategory: Set<PatternCategory> = [.agar]

    init(dismiss: @escaping () -> Void) {
        _patternSelectManager = StateObject(wrappedValue: .init(presented: .init(get: { true }, set: { _ in dismiss() })))
    }
    
    // MARK: Views
    
    var patternURLs: [URL] {
        guard let category = selectionCategory.first else { return [] }
        return patternSelectManager.urlsByCategory[category] ?? []
    }

    var body: some View {
        NavigationView {
            List(selection: $selectionCategory) {
                
                // TODO: 現時点ではスターによるフィルタリングは機能していないので、そのうち実装する。
                Section(header: Text("Search options")) {
                    Toggle("Star only", isOn: $setting.isFilterByStared.animation())
                        .enabled(authentication.isSignIn)
                }

                Section {
                    ForEach(PatternCategory.allCases) { category in
                        Text(category.rawValue)
                            .tag(category)
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

                Button("Cancel", action: patternSelectManager.cancel)
                    .padding()
            }
            .padding()
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

//struct BoardListView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardListView(dismiss: {})
//    }
//}
