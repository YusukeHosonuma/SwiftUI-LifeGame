//
//  LifeGameAppApp.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import SwiftUI
import Firebase

// TODO: プレビュー時でもインスタンス化されてるのでコスト
private let settingEnvironment: SettingEnvironment = .shared

@main
struct Application: App {
    @StateObject var boardRepository = FirestoreBoardRepository()
    @StateObject var viewModel = MainGameViewModel()
    #if os(macOS)
    @StateObject var fileManager = LifeGameFileManager()
    #endif

    init() {
        FirebaseApp.configure()

        #if os(macOS)
        // TODO: How can disable scroll-bounce in mac?
        #elseif os(iOS)
        // ref: https://stackoverflow.com/a/59926791
        UIScrollView.appearance().bounces = false
        #endif
    }
    
    var body: some Scene {
        #if os(macOS)
        WindowGroup {
            MacRootView(viewModel: viewModel)
                .environmentObject(settingEnvironment)
                .environmentObject(boardRepository)
                .environmentObject(fileManager)
        }
        .commands {
            LifeGameCommands(viewModel: viewModel,
                             boardRepository: boardRepository,
                             fileManager: fileManager)
                // ❗API is not supported in beta4
                // .environmentObject(boardRepository)
        }
        #else
        WindowGroup {
            RootView(viewModel: viewModel)
                .environmentObject(settingEnvironment)
                .environmentObject(boardRepository)
                .onOpenURL { url in
                    let documentID = url.lastPathComponent
                    guard documentID != "0" else { return }
                    
                    // TODO: ユーザが編集していた場合は上書きしてしまうことになるので、ちょっと考える。
                    
                    Firestore.firestore()
                        .collection("presets")
                        .document(documentID)
                        .getDocument { (snapshot, error) in
                            guard let snapshot = snapshot else {
                                print("Error fetching snapshot results: \(error!)")
                                return
                            }
                            
                            guard let document = try! snapshot.data(as: BoardDocument.self) else {
                                fatalError()
                            }
                            
                            let board = document.makeBoard()
                            LifeGameContext.shared.setBoard(board)
                        }
                }
        }
        #endif
        
        #if os(macOS)
        Settings {
            PreferenceView()
                .environmentObject(settingEnvironment)
        }
        #endif
    }
}
