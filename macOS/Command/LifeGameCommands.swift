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
    @ObservedObject var viewModel: MainGameViewModel
    @ObservedObject var boardRepository: FirestoreBoardRepository
    @ObservedObject var fileManager: LifeGameFileManager

    var body: some Commands {
        // TODO: 将来的にはドキュメントベースのアプリで構築することも検討

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
        
        CommandMenu("Game") {
            Section {
                // TODO: beta4 bug (maybe...)❗
                // Not update disabled state when viewModel was changed.

                Button("Start", action: viewModel.tapPlayButton)
                    .keyboardShortcut("r")
                    .disabled(viewModel.playButtonDisabled)
                
                Button("Stop", action: viewModel.tapStopButton)
                    .keyboardShortcut("x")
                    .disabled(viewModel.stopButtonDisabled)
                
                Button("Next", action: viewModel.tapNextButton)
                    .keyboardShortcut("n") // Next
                    .disabled(viewModel.nextButtonDisabled)
            }
            
            Section {
                Button("Clear", action: viewModel.tapClear)
                    .keyboardShortcut("k", modifiers: [.command, .shift])
            }
        }
    }
    
    // MARK: Actions

    private func saveAs() {
        fileManager.saveAs(board: viewModel.board.board)
    }
    
    private func save() {
        fileManager.save(board: viewModel.board.board)
    }
    
    private func open() {
        guard let board = fileManager.open() else { return }
        viewModel.loadBoard(board)
    }
    
    private func exportPresets() {
        let presets = boardRepository.items.map(BoardPresetFile.init)
        fileManager.exportPresets(presets)
    }
}
