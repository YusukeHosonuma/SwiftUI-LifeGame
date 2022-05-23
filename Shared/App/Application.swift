//
//  LifeGameAppApp.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import LifeGame
import Core
#if DEBUG && os(iOS)
import SwiftUISimulator
#endif

@main
struct Application: App {
    @Environment(\.scenePhase) private var scenePhase
    
    #if os(iOS)
    // TODO: とりあえず実験的に`@AppStorage`を使ってみたが、ボードの状態を保存するのは用途として間違っているので、たぶん将来的に削除する。
    @AppStorage(wrappedValue: LifeGameBoard(size: 32), "currentBoard") private var currentBoard: LifeGameBoard
    #endif
    
    // Note: ✅
    // SwiftUI 以外の文脈で参照する必要がなければ、`.shared`を用意しなくてもよい。
    
    @StateObject var boardManager = BoardManager.shared
    @StateObject var gameManager = GameManager.shared
    @StateObject var settingEnvironment = SettingEnvironment.shared
    @StateObject var networkMonitor = NetworkMonitor()
    @StateObject var authentication = Authentication.shared
    @StateObject var applicationRouter = ApplicationRouter.shared
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
        // `WindowGroup`をもう一つ宣言しても無視されてしまいマルチウィンドウのアプリにはならない。（macOS-beta 5❗）
        // 現時点では仕様なのかバグなのか、他にやり方があるのかは不明。
        
        WindowGroup {
            content()
        }
        .commands {
            // Note: ✅
            // `Commands`には environmentObject を利用できない仕様っぽい。
            //
            // ```
            // .environmentObject(boardRepository)
            // ```
            LifeGameCommands(boardManager: boardManager,
                             gameManager: gameManager,
                             fileManager: fileManager)
        }

        Settings {
            PreferenceView()
                .environmentObject(settingEnvironment)
        }
        #else
        WindowGroup {
            #if DEBUG
            SimulatorView {
                content()
            }
            #else
            content()
            #endif
        }
        .commands {
            // Note:
            // 少なくとも iPad Simulator 上ではショートカットキーを受け付けていないように見える（beta 6）❗
            LifeGameCommands(boardManager: boardManager,
                             gameManager: gameManager)
        }
        #endif
    }
    
    // MARK: Private
    
    private func content() -> some View {
        #if os(macOS)
        configure(MacRootView())
            .environmentObject(fileManager)
        #else
        configure(RootView())
            .onAppear {
                boardManager.setLifeGameBoard(board: currentBoard)
            }
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    AppLogger.appLifecycle.info("Will active...")
                    
                case .inactive:
                    AppLogger.appLifecycle.info("Will inactive...")
                    gameManager.stop()
                    currentBoard = boardManager.board // タスクスイッチャーから直接killされると`background`を介さないのでここで保存

                case .background:
                    AppLogger.appLifecycle.info("Will background...")

                @unknown default:
                    fatalError()
                }
            }
        #endif
    }
    
    private func configure<T: View>(_ view: T) -> some View {
        view
            .environmentObject(boardManager)
            .environmentObject(gameManager)
            .environmentObject(settingEnvironment)
            .environmentObject(authentication)
            .environmentObject(networkMonitor)
            .environmentObject(applicationRouter)
            //
            // Handle launch events from widgets in the current window.
            //
            // 🌱 Special Thanks
            // https://stackoverflow.com/questions/66647052/why-does-url-scheme-onopenurl-in-swiftui-always-open-a-new-window
            //
            .handlesExternalEvents(preferring: ["board"], allowing: ["*"])
            .onOpenURL(perform: applicationRouter.performURL) // 🚀 Ignite
    }
}
