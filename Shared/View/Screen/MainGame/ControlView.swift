//
//  ControlView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/02.
//

import SwiftUI

// FIXME: mac版の対応が終わったら消す
struct TopControlView: View {
    @EnvironmentObject var setting: SettingEnvironment
    @ObservedObject var viewModel: MainGameViewModel

    // MARK: Private
    
    @State private var isPresentedAlert = false
    @State private var isPresentedSheet = false
    
    // MARK: View
    
    var body: some View {
        #if os(macOS)
        VStack {
            HStack {
                Spacer()
                clearButton()
            }
            presetsMenuButton()
        }
        .padding()
        #else
        HStack {
            clearButton()
            presetsMenuButton()
            Spacer()
            //Stepper(value: $setting.zoomLevel, in: 0...10) {}
        }
        .padding([.leading, .trailing])
        #endif
    }
    
    private func clearButton() -> some View {
        Button("Clear") {
            isPresentedAlert.toggle()
        }
        .buttonStyle(ButtonStyleRounded(color: .red))
        .alert(isPresented: $isPresentedAlert, content: clearAlert)
    }
    
    @ViewBuilder
    private func presetsMenuButton() -> some View {
        #if os(macOS)
        Menu("Presets", content: presetsMenuContent)
        #else
        Menu(content: presetsMenuContent) {
            Button("Presets") {}.buttonStyle(ButtonStyleRounded())
        }
        #endif
    }
    
    @ViewBuilder
    private func presetsMenuContent() -> some View {
        // Note:
        // バグか仕様なのか分からないが、実際のボタン表示は逆順になる。（Xcode 12 beta3）
        //
        // ...
        // -----
        // Random
        //
        
        Button("Random") {
            viewModel.tapRandomButton()
        }
        Divider()
        ForEach(BoardPreset.allCases, id: \.rawValue) { preset in
            Button(preset.displayText) {
                viewModel.selectPreset(preset)
            }
        }
    }
    
    // MARK: Actions
    
    private func clearAlert() -> Alert {
        Alert(
            title: Text("Do you want to clear?"),
            primaryButton: .cancel(),
            secondaryButton: .destructive(Text("Clear"), action: viewModel.tapClear))
    }
}

struct ControlView: View {
    @ObservedObject var viewModel: MainGameViewModel
    
    // MARK: View
    
    var body: some View {
        HStack {
            // TODO: やっつけなのであとでリファクタ
            if !viewModel.playButtonDisabled {
                Button(action: viewModel.tapPlayButton) {
                    Image(systemName: "play.fill")
                }
                .disabled(viewModel.playButtonDisabled)
            } else {
                Button(action: viewModel.tapStopButton) {
                    Image(systemName: "stop.fill")
                }
                .buttonStyle(ButtonStyleCircle(color: .orange))
                .disabled(viewModel.stopButtonDisabled)
            }

            Button(action: viewModel.tapNextButton) {
                Image(systemName: "arrow.right.to.line.alt")
            }
            .disabled(viewModel.nextButtonDisabled)

            Spacer()

            ActionMenu(viewModel: viewModel) {
                Button(action: viewModel.tapNextButton) {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .buttonStyle(ButtonStyleCircle())
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        TopControlView(viewModel: MainGameViewModel())
            .previewDevice("iPod touch (7th generation)")
    }
}
