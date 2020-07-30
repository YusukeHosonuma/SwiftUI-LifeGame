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
    @StateObject var viewModel = MainGameViewModel()

    var body: some View {
        VStack {
            Spacer()
            TopControlView(viewModel: viewModel)
            BoardContainerView(viewModel: viewModel)
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
            MainGameView()
                .previewDevice("iPhone SE (2nd generation)")
                .preferredColorScheme(.light)
            MainGameView()
                .previewDevice("iPhone SE (2nd generation)")
                .preferredColorScheme(.dark)
        }
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

struct BoardContainerView: View {
    @ObservedObject var viewModel: MainGameViewModel

    var body: some View {
        let boardView = BoardView(viewModel: viewModel, cellWidth: 20, cellPadding: 2)

        GeometryReader { geometry in
            VCenter {
                HCenter {
                    if boardView.width > geometry.size.width {
                        ScrollView([.vertical, .horizontal]) {
                            boardView
                        }
                    } else {
                        boardView
                    }
                }
            }
        }
    }
}

struct BoardView: View {
    @ObservedObject var viewModel: MainGameViewModel
    
    var cellWidth: CGFloat
    var cellPadding: CGFloat

    // MARK: Computed properties
    
    var width: CGFloat {
        (cellWidth + (cellPadding * 2)) * CGFloat(viewModel.board.size)
    }

    // MARK: Private

    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @EnvironmentObject private var setting: SettingEnvironment

    // MARK: View

    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.board.rows.withIndex(), id: \.0) { y, row in
                HStack(spacing: 0) {
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
