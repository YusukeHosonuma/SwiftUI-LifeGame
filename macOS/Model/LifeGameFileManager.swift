//
//  LifeGameFileManager.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/10.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import LifeGame

// TODO: fileImporter / fileExporter を使った実装に変更する。

final class LifeGameFileManager: ObservableObject {
    @Published var latestURL: URL?
    
    func save(board: Board<Cell>) {
        if let url = latestURL {
            save(to: url, board: board)
        } else {
            saveAs(board: board)
        }
    }
    
    func saveAs(board: Board<Cell>) {
        let panel = NSSavePanel()
        panel.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        panel.canCreateDirectories = true
        panel.showsTagField = true
        panel.nameFieldStringValue = latestURL?.lastPathComponent ?? "Untitled"
        panel.allowedContentTypes = [UTType(exportedAs: "tech.penginmura.LifeGameApp.board")]

        if panel.runModal() == .OK {
            guard let url = panel.url else { fatalError() }
            save(to: url, board: board)
        }
    }
    
    func open() -> Board<Cell>? {
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
                latestURL = url
                return board
            } catch {
                fatalError("Failed to read file: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func exportPresets(_ files: [BoardPresetFile]) {
        let panel = NSSavePanel()
        panel.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        panel.canCreateDirectories = true
        panel.showsTagField = true
        panel.nameFieldStringValue = "LifeGamePresets"
        panel.allowedContentTypes = [UTType.json]
        
        if panel.runModal() == .OK {
            guard let url = panel.url else { fatalError() }
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(files)
                try data.write(to: url)
            } catch {
                fatalError("Failed to write file: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: private
    
    private func save(to url: URL, board: Board<Cell>) {
        do {
            let data = try JSONEncoder().encode(board)
            try data.write(to: url)
        } catch {
            fatalError("Failed to write file: \(error.localizedDescription)")
        }
        latestURL = url
    }
}
