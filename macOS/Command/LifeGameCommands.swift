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
                    .keyboardShortcut("n") // Next `s`tep
                    .disabled(viewModel.nextButtonDisabled)
            }
            
            Section {
                Button("Clear", action: viewModel.tapClear)
                    .keyboardShortcut("k", modifiers: [.command, .shift])
            }
        }
    }
    
    // MARK: Actions
    
    private func save() {
        let panel = NSSavePanel()
        panel.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        panel.canCreateDirectories = true
        panel.showsTagField = true
        panel.nameFieldStringValue = "Untitled"
        panel.allowedContentTypes = [UTType(exportedAs: "tech.penginmura.LifeGameApp.board")]

        if panel.runModal() == .OK {
            guard let url = panel.url else { fatalError() }
            do {
                let data = try JSONEncoder().encode(viewModel.board.board)
                try data.write(to: url)
            } catch {
                fatalError("Failed to write file: \(error.localizedDescription)")
            }
        }
    }
    
    private func open() {
        let panel = NSOpenPanel()
        panel.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        panel.canCreateDirectories = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = [UTType(exportedAs: "tech.penginmura.LifeGameApp.board")]

        if panel.runModal() == .OK {
            guard let url = panel.url else { fatalError() }
            do {
                let data = try Data(contentsOf: url)
                let board = try JSONDecoder().decode(Board<Cell>.self, from: data)
                viewModel.loadBoard(board)
            } catch {
                fatalError("Failed to read file: \(error.localizedDescription)")
            }
        }
    }
    
    private func exportPresets() {
        let panel = NSSavePanel()
        panel.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        panel.canCreateDirectories = true
        panel.showsTagField = true
        panel.nameFieldStringValue = "LifeGamePresets"
        panel.allowedContentTypes = [UTType.json]
        
        if panel.runModal() == .OK {
            guard let url = panel.url else { fatalError() }
            
            let items = boardRepository.items.map(BoardPresetFile.init)
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(items)
                try data.write(to: url)
            } catch {
                fatalError("Failed to write file: \(error.localizedDescription)")
            }
        }
    }
}
