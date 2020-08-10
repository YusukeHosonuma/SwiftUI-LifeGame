//
//  LifeGameCommands.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/07/28.
//

import SwiftUI
import UniformTypeIdentifiers

struct LifeGameCommands: Commands {    
    @ObservedObject var viewModel: MainGameViewModel
    @ObservedObject var boardRepository: FirestoreBoardRepository

    // TODO: beta4 bug (maybe...)❗
    // Not update disabled state when viewModel was changed.
    
    var body: some Commands {
        CommandGroup(before: .saveItem) {
            Section {
                Button("Export presets...", action: showSaveDialog)
            }
        }
        
        CommandMenu("Game") {
            Section {
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
            
            // TODO: Don't apply section... beta3 bug?

            Section {
                Button("Clear", action: viewModel.tapClear)
                    .keyboardShortcut("k", modifiers: [.command, .shift])
            }
        }
    }
    
    func showSaveDialog() {
        let panel = NSSavePanel()
        panel.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        panel.canCreateDirectories = true
        panel.showsTagField = true
        panel.nameFieldStringValue = "LifeGamePresets"
        panel.allowedContentTypes = [UTType.json]
        
        if panel.runModal() == .OK {
            guard let url = panel.url else { fatalError() } // 複数選択でなければ発生しないらしい
            
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
