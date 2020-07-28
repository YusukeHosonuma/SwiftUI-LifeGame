//
//  LifeGameCommands.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/07/28.
//

import SwiftUI

struct LifeGameCommands: Commands {
    @ObservedObject var viewModel: MainGameViewModel
    
    // TODO: ❗beta3 bug (maybe...)❗
    // Not update disabled state when viewModel was changed.
    
    var body: some Commands {
        CommandMenu("Game") {
            Section {
                Button("Start", action: viewModel.tapPlayButton)
                    .keyboardShortcut("r")
                    .disabled(viewModel.playButtonDisabled)
                
                Button("Stop", action: viewModel.tapStopButton)
                    .keyboardShortcut("x")
                    .disabled(viewModel.stopButtonDisabled)
                
                Button("Next", action: viewModel.tapNextButton)
                    .keyboardShortcut("s") // Next `s`tep
                    .disabled(viewModel.nextButtonDisabled)
            }
            
            // TODO: Don't apply section... beta3 bug?

            Section {
                Button("Clear", action: viewModel.tapClear)
                    .keyboardShortcut("k", modifiers: [.command, .shift])
            }
        }
    }
}
