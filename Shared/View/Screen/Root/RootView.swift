//
//  ContainerView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel: MainGameViewModel
    @EnvironmentObject var setting: SettingEnvironment
    
    private var cellWidth: CGFloat {
        CGFloat(20 + (setting.zoomLevel - 5) * 2)
    }
    
    var body: some View {
        #if os(macOS)
        NavigationView {
            List {
                Section(header: Text("Size")) {
                    ForEach([13, 17, 21].withIndex(), id: \.1) { index, size in
                        Text("\(size) x \(size)")
                            .onTapGesture {
                                setting.boardSize = size
                            }
                    }
                }
                
                Section(header: Text("Presets")) {
                    ForEach(BoardPreset.allCases, id: \.rawValue) { preset in
                        Text(preset.displayText)
                            .onTapGesture {
                                viewModel.selectPreset(preset)
                            }
                    }
                    Divider()
                    
                    Text("Random")
                        .onTapGesture(perform: viewModel.tapRandomButton)
                }

                Section(header: Text("Animation Speed")) {
                    Slider(value: $viewModel.speed, in: 0...1, onEditingChanged: viewModel.onSliderChanged)
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 212, idealWidth: 212, maxWidth: 212, maxHeight: .infinity)
            
            BoardView(viewModel: viewModel, cellWidth: cellWidth, cellPadding: 1)
        }
        .navigationTitle("\(setting.boardSize) x \(setting.boardSize)")
        .toolbar {
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
        #else
        TabView {
            MainGameView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("GAME")
                }
            SettingView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("SETTING")
                }
        }
        #endif
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: MainGameViewModel())
    }
}
