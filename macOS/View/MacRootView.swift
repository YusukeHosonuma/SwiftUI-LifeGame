//
//  MacRootView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/07.
//

import SwiftUI

struct MacRootView: View {
    @ObservedObject var viewModel: MainGameViewModel
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var fileManager: LifeGameFileManager

    private var title: String {
        fileManager.latestURL?.lastPathComponent ?? "Untitled"
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Presets")) {
//                    ForEach(BoardPreset.allCases, id: \.rawValue) { preset in
//                        Text(preset.displayText)
//                            .onTapGesture {
//                                viewModel.selectPreset(preset)
//                            }
//                    }
//                    Divider()
                    
                    Text("Random")
                        .onTapGesture(perform: viewModel.tapRandomButton)
                }

                Section(header: Text("Animation Speed")) {
                    Slider(value: $viewModel.speed, in: 0...1, onEditingChanged: viewModel.onSliderChanged)
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 212, idealWidth: 212, maxWidth: 212, maxHeight: .infinity)
            
            ContentView(viewModel: viewModel, zoomLevel: setting.zoomLevel)
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                BoardSizeMenu(size: $setting.boardSize)
            }

            ToolbarItem(placement: .status) {
                Button(action: viewModel.tapPlayButton) {
                    Image(systemName: "play.fill")
                }
                .disabled(viewModel.playButtonDisabled)
            }
            
            ToolbarItem(placement: .status) {
                Button(action: viewModel.tapStopButton) {
                    Image(systemName: "stop.fill")
                }
                .disabled(viewModel.stopButtonDisabled)
            }
            
            ToolbarItem(placement: .status) {
                Button(action: viewModel.tapNextButton) {
                    Image(systemName: "arrow.right.to.line.alt")
                }
                .disabled(viewModel.nextButtonDisabled)
            }
            
            ToolbarItem(placement: .status) {
                Button(action: viewModel.tapClear) {
                    Image(systemName: "trash")
                }
            }
            
            // TODO: refactor
            ToolbarItem(placement: .status) {
                Button(action: {
                    if setting.zoomLevel < 10 {
                        setting.zoomLevel += 1
                    }
                }) {
                    Image(systemName: "plus.magnifyingglass")
                }
            }
            
            ToolbarItem(placement: .status) {
                Button(action: {
                    if 0 < setting.zoomLevel {
                        setting.zoomLevel -= 1
                    }
                }) {
                    Image(systemName: "minus.magnifyingglass")
                }
            }
        }
    }
}

//struct MacRootView_Previews: PreviewProvider {
//    static var previews: some View {
//        MacRootView()
//    }
//}
