//
//  ContentView.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import SwiftUI
import LifeGame

// MARK: - Main view

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            Spacer()
            TopControlView(viewModel: viewModel)
            BoardView(viewModel: viewModel)
            ControlView(viewModel: viewModel)
            Spacer()
            SpeedSliderView(viewModel: viewModel)
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone SE (2nd generation)")
                .preferredColorScheme(.light)
            ContentView()
                .previewDevice("iPhone SE (2nd generation)")
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Subviews

struct TopControlView: View {
    @ObservedObject var viewModel: ContentViewModel

    // MARK: Private
    
    @State private var isPresentedAlert = false
    @State private var isPresentedSheet = false
    
    private var sheetButtons: [ActionSheet.Button] {
        BoardPreset.allCases.map { preset in
            .default(Text(preset.displayText)) { viewModel.selectPreset(preset) }
        } + [.cancel()]
    }
    
    // MARK: View
    
    var body: some View {
        HStack {
            Button("Clear") {
                isPresentedAlert.toggle()
            }
            .buttonStyle(RoundStyle(color: .red))
            .alert(isPresented: $isPresentedAlert, content: clearAlert)
            
            Spacer()
            
            Button("Presets") {
                isPresentedSheet.toggle()
            }
            .buttonStyle(RoundStyle())
            .actionSheet(isPresented: $isPresentedSheet, content: presetsActionSheet)
        }
        .padding()
    }
    
    private func clearAlert() -> Alert {
        Alert(
            title: Text("Do you want to clear?"),
            primaryButton: .cancel(),
            secondaryButton: .destructive(Text("Clear"), action: viewModel.tapClear))
    }
    
    private func presetsActionSheet() -> ActionSheet {
        ActionSheet(title: Text("Select from presets"), buttons: sheetButtons)
    }
}

struct BoardView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    // MARK: Private
    
    private let cellSize: CGFloat = 20
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    // MARK: View

    var body: some View {
        VStack {
            ForEach(viewModel.board.rows.withIndex(), id: \.0) { y, row in
                HStack {
                    ForEach(row.withIndex(), id: \.0) { x, cell in
                        cellButton(x: x, y: y, cell: cell)
                    }
                }
                .padding(4)
            }
        }
    }
    
    private func cellButton(x: Int, y: Int, cell: Cell) -> some View {
        Button(action: {
            viewModel.tapCell(x: x, y: y)
        }) {
            Text("") // TODO: What better to do it?
                .frame(width: cellSize, height: cellSize, alignment: .center)
                .background(cellBackgroundColor(cell: cell))
                .border(Color.gray)
        }
    }
    
    private func cellBackgroundColor(cell: Cell) -> Color {
        switch (colorScheme, cell) {
        case (.light, .die):   return .white
        case (.light, .alive): return .black
        case (.dark,  .die):   return .black
        case (.dark,  .alive): return .white
        case (_, _):
            fatalError()
        }
    }
}

struct ControlView: View {
    @ObservedObject var viewModel: ContentViewModel
    
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
        .buttonStyle(CircleStyle())
    }
}

struct SpeedSliderView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Text("Speed")
            Slider(value: $viewModel.speed, in: 0...1, onEditingChanged: viewModel.onSliderChanged)
                .padding()
        }
    }
}
