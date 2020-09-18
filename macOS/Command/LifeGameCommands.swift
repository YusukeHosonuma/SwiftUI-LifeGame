//
//  LifeGameCommands.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/07/28.
//

import SwiftUI
import LifeGame
import UniformTypeIdentifiers

struct LifeGameCommands: Commands {
    @ObservedObject var boardManager: BoardManager // TODO: パフォーマンス的に少し無駄かも
    @ObservedObject var gameManager: GameManager
    @ObservedObject var patternRepository: FirestorePatternRepository
    #if os(macOS)
    @ObservedObject var fileManager: LifeGameFileManager
    #endif
    
    var body: some Commands {
        // TODO: 将来的にはドキュメントベースのアプリで構築することも検討

        #if os(macOS)
        CommandGroup(before: .saveItem) {
            Section {
                Button("Open...", action: open)
                    .keyboardShortcut("o")
            }
            Section {
                Button("Save", action: save)
                    .keyboardShortcut("s")
                Button("Save As...", action: saveAs)
                    .keyboardShortcut("S")
            }
            Section {
                Button("Export Presets...", action: exportPresets)
            }
        }
        #endif

        CommandMenu("Game") {
            Section {
                // TODO: macOS-beta 5 bug (maybe...)❗
                // Not update disabled state when viewModel was changed.

                Button("Start", action: gameManager.play)
                    .keyboardShortcut("r")
                    .disabled(gameManager.state.canPlay)

                Button("Stop", action: gameManager.stop)
                    .keyboardShortcut("x")
                    .disabled(gameManager.state.canStop)

                Button("Next", action: gameManager.next)
                    .keyboardShortcut("n") // Next
                    .disabled(gameManager.state.canNext)
            }
            
            Section {
                Button("Clear", action: gameManager.clear)
                    .keyboardShortcut("k", modifiers: [.command, .shift])
            }
        }
    }
    
    // MARK: Actions

    #if os(macOS)
    private func saveAs() {
        // FIXME: `@Published`なので厳密に言えば陳腐化した値を読んでしまう可能性がありえそう。なので直したほうがベター。
        fileManager.saveAs(board: boardManager.board.board)
    }
    
    private func save() {
        fileManager.save(board: boardManager.board.board)
    }
    
    private func open() {
        guard let board = fileManager.open() else { return }
        gameManager.setBoard(board: board)
    }
    
    // TODO: 開発用のメニューだから消せるはず
    private func exportPresets() {
//        let presets = boardRepository.items.map(BoardPresetFile.init)
//        fileManager.exportPresets(presets)
    }
    #endif
}
