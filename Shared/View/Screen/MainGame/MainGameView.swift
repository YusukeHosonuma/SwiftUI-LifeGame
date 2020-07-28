//
//  MainGameView.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import SwiftUI
import LifeGame

// MARK: - Main view

struct MainGameView: View {
    @ObservedObject var viewModel: MainGameViewModel

    var body: some View {
        VStack {
            Spacer()
            TopControlView(viewModel: viewModel)
            BoardView(viewModel: viewModel)
            ControlView(viewModel: viewModel)
            SpeedSliderView(viewModel: viewModel)
            Spacer()
        }
    }
}

// MARK: - Preview

struct MainGameView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            view(.light)
            view(.dark)
        }
    }

    static func view(_ colorScheme: ColorScheme) -> some View {
        MainGameView(viewModel: MainGameViewModel())
            .previewDevice("iPhone SE (2nd generation)")
            .preferredColorScheme(colorScheme)
    }
}

// MARK: - Subviews

struct TopControlView: View {
    @ObservedObject var viewModel: MainGameViewModel

    // MARK: Private
    
    @State private var isPresentedAlert = false
    @State private var isPresentedSheet = false
    
    // MARK: View
    
    func clearButton() -> some View {
        Button("Clear") {
            isPresentedAlert.toggle()
        }
        .buttonStyle(ButtonStyleRounded(color: .red))
        .alert(isPresented: $isPresentedAlert, content: clearAlert)
    }
    
    func presetsMenu() -> some View {
        let contents = ForEach(BoardPreset.allCases, id: \.rawValue) { preset in
            Button(preset.displayText) {
                viewModel.selectPreset(preset)
            }
        }
        
        #if os(macOS)
        return Menu("Presets") { contents }
        #else
        return Menu(content: { contents }, label: {
            Button("Presets") {}.buttonStyle(ButtonStyleRounded())
        })
        #endif
    }
    
    var body: some View {
        #if os(macOS)
        VStack {
            HStack {
                Spacer()
                clearButton()
            }
            presetsMenu()
        }
        .padding()
        #else
        HStack {
            clearButton()
            Spacer()
            presetsMenu()
        }
        .padding()
        #endif
    }
    
    private func clearAlert() -> Alert {
        Alert(
            title: Text("Do you want to clear?"),
            primaryButton: .cancel(),
            secondaryButton: .destructive(Text("Clear"), action: viewModel.tapClear))
    }
}

struct BoardView: View {
    @ObservedObject var viewModel: MainGameViewModel
    
    // MARK: Private
    
    private let cellSize: CGFloat = 20
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @EnvironmentObject private var setting: SettingEnvironment
    
    // MARK: View

    var body: some View {
        VStack {
            ForEach(viewModel.board.rows.withIndex(), id: \.0) { y, row in
                HStack {
                    ForEach(row.withIndex(), id: \.0) { x, cell in
                        cellButton(x: x, y: y, cell: cell)
                    }
                }
            }
        }
    }
    
    private func cellButton(x: Int, y: Int, cell: Cell) -> some View {
        CellView(color: cellBackgroundColor(cell: cell), size: cellSize)
            .onTapGesture(perform: {
                viewModel.tapCell(x: x, y: y)
            })
    }
    
    private func cellBackgroundColor(cell: Cell) -> Color {
        switch (colorScheme, cell) {
        case (.light, .die):   return .white
        case (.light, .alive): return setting.lightModeColor
        case (.dark,  .die):   return .black
        case (.dark,  .alive): return setting.darkModeColor
        case (_, _):
            fatalError()
        }
    }
}

struct ControlView: View {
    @ObservedObject var viewModel: MainGameViewModel
    
    // MARK: View
    
    var body: some View {
        HStack {
            Button(action: viewModel.tapPlayButton) {
                Image(systemName: "play.fill")
            }
            .disabled(viewModel.playButtonDisabled)
            
            Button(action: viewModel.tapStopButton) {
                Image(systemName: "stop.fill")
            }
            .disabled(viewModel.stopButtonDisabled)
            
            Spacer()
            
            Button("Next", action: viewModel.tapNextButton)
                .disabled(viewModel.nextButtonDisabled)
        }
        .padding()
        .buttonStyle(ButtonStyleCircle())
    }
}

struct SpeedSliderView: View {
    @ObservedObject var viewModel: MainGameViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "tortoise.fill")
            Slider(value: $viewModel.speed, in: 0...1, onEditingChanged: viewModel.onSliderChanged)
            Image(systemName: "hare.fill")
        }
        .padding()
    }
}
