//
//  ContentView.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import SwiftUI
import LifeGame

struct ContentView: View {
    @StateObject var gameManager = GameManager()

    var body: some View {
        VStack {
            Spacer()
            TopControlView(gameManager: gameManager)
            BoardView(board: $gameManager.board)
            ControlView(gameManager: gameManager)
            Spacer()
            VStack {
                Text("Speed")
                Slider(value: $gameManager.speed, in: 0...1) { ediging in
                    if ediging && gameManager.animationState == .inProgress {
                        gameManager.pauseAnimation()
                    } else {
                        if gameManager.animationState == .paused {
                            gameManager.startAnimation()
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct TopControlView: View {
    @State var isPresentAlert = false
    @State var isPresentSheet = false
    @ObservedObject var gameManager: GameManager

    var body: some View {
        HStack {
            Button("Clear") {
                isPresentAlert = true
            }
            .buttonStyle(RoundStyle(color: .red))
            .alert(isPresented: $isPresentAlert) {
                Alert(
                    title: Text("Do you want to clear?"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Clear"), action: { gameManager.clear() }))
            }
            Spacer()
            Button("Presets") {
                isPresentSheet = true
            }
            .buttonStyle(RoundStyle())
            .actionSheet(isPresented: $isPresentSheet) {
                ActionSheet(title: Text("Select from presets."), buttons: [
                    .default(Text("Space ship")) {
                        gameManager.applyPreset(.spaceShip)
                    },
                    .default(Text("Nebura")) {
                        gameManager.applyPreset(.nebura)
                    },
                    .cancel()
                ])
            }
            
        }
        .padding()
    }
}

struct BoardView: View {
    @Binding var board: Board
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    func cellBackgroundColor(cell: CellState) -> Color {
        switch colorScheme {
        case .light:
            return cell == .alive ? Color.black : Color.white

        case .dark:
            return cell == .alive ? Color.white : Color.black
            
        @unknown default:
            fatalError()
        }
    }
    
    var body: some View {
        VStack {
            ForEach(board.rows.withIndex(), id: \.0) { y, row in
                HStack {
                    ForEach(row.withIndex(), id: \.0) { x, cell in
                        Button(action: {
                            board.toggle(x: x, y: y)
                        }) {
                            Text("")
                                .frame(width: 20, height: 20, alignment: .center)
                                .background(cellBackgroundColor(cell: cell))
                                .border(Color.gray)
                        }
                    }
                }
                .padding(4)
            }
        }
    }
}

struct ControlView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        HStack {
            Button(action: {
                gameManager.startAnimation()
            }) {
                Image(systemName: "play.fill")
            }
            .disabled(gameManager.animationState != .stop)
            
            Button(action: {
                gameManager.stopAnimation()
            }) {
                Image(systemName: "stop.fill")
            }
            .disabled(gameManager.animationState != .inProgress)
            
            Spacer()
            
            Button("Next") {
                gameManager.stepNext()
            }
            .disabled(gameManager.animationState != .stop)
        }
        .padding()
        .buttonStyle(CircleStyle())
    }
}

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
