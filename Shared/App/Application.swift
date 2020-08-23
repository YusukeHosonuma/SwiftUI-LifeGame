//
//  LifeGameAppApp.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import LifeGame

@main
struct Application: App {
    @Environment(\.scenePhase) private var scenePhase
    
    #if os(iOS)
    // TODO: とりあえず実験的に`@AppStorage`を使ってみたが、ボードの状態を保存するのは用途として間違っているので、たぶん将来的に削除する。
    @AppStorage(wrappedValue: LifeGameBoard(size: 32), "currentBoard") private var currentBoard: LifeGameBoard
    #endif
    
    // Note: ✅
    // SwiftUI 以外の文脈で参照する必要がなければ、`.shared`を用意しなくてもよい。
    
    @StateObject var settingEnvironment = SettingEnvironment.shared
    @StateObject var boardRepository = FirestoreBoardRepository.shared // TODO: Mac側のアカウント対応が終わったら不要になるはず。
    @StateObject var boardStore = BoardStore.shared
    @StateObject var viewModel = MainGameViewModel()
    @StateObject var networkMonitor = NetworkMonitor()
    @StateObject var authentication = Authentication.shared
    #if os(macOS)
    @StateObject var fileManager = LifeGameFileManager()
    #endif

    init() {
        FirebaseApp.configure()

        // ref: https://firebase.google.com/docs/auth/ios/single-sign-on?hl=ja
        do {
            try Auth.auth().useUserAccessGroup("P437HSA6PY.shared") // TODO: そのうちチームIDを除外したい
        } catch let error as NSError {
            fatalError("Error changing user access group: \(error.localizedDescription)")
        }
        
        #if os(iOS)
        UITextView.appearance().backgroundColor = .clear
        #endif
    }
    
    var body: some Scene {
        #if os(macOS)

        // Note:
        // `WindowGroup`をもう一つ宣言しても無視されてしまいマルチウィンドウのアプリにはならない。（beta5❗）
        // 現時点では仕様なのかバグなのか、他にやり方があるのかは不明。
        
        WindowGroup {
            MacRootView(viewModel: viewModel)
                .environmentObject(settingEnvironment)
                .environmentObject(boardRepository)
                .environmentObject(fileManager)
                .environmentObject(authentication)
        }
        .commands {
            LifeGameCommands(viewModel: viewModel,
                             boardRepository: boardRepository,
                             fileManager: fileManager)
                // ❗API is not supported in macOS-beta4
                // .environmentObject(boardRepository)
        }
        #else
        WindowGroup {
            RootView(viewModel: viewModel)
                .environmentObject(settingEnvironment)
                .environmentObject(boardRepository)
                .environmentObject(boardStore)
                .environmentObject(networkMonitor)
                .environmentObject(authentication)
                .onOpenURL { url in
                    let documentID = url.lastPathComponent
                    guard documentID != "0" else { return }
                    
                    // TODO: ユーザが編集していた場合は上書きしてしまうことになるので、ちょっと考える。
                    
                    boardRepository
                        .get(by: documentID) { (document) in
                            let board = document.makeBoard()
                            LifeGameContext.shared.setBoard(board)
                        }
                }
                .onAppear {
                    viewModel.setBoard(board: currentBoard)
                }
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .active:
                        AppLogger.appLifecycle.info("Will active...")
                        
                    case .inactive:
                        AppLogger.appLifecycle.info("Will inactive...")
                        viewModel.tapStopButton()
                        currentBoard = viewModel.board // タスクスイッチャーから直接killされると`background`を介さないのでここで保存

                    case .background:
                        AppLogger.appLifecycle.info("Will background...")

                    @unknown default:
                        fatalError()
                    }
                }
        }
        .commands {
            // Note:
            // 少なくとも iPad Simulator 上ではショートカットキーを受け付けていないように見える（beta5）❗
            LifeGameCommands(viewModel: viewModel,
                             boardRepository: boardRepository)
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
