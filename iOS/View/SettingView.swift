//
//  SettingView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI

private let CellSize: CGFloat = 20

struct SettingView: View {

    // MARK: Dependencies
    
    @EnvironmentObject private var setting: SettingEnvironment

    // MARK: Local Properties
    
    @State private var isAlertPresented = false
    @State private var isPresentedChangeSizeAlert = [false, false, false]
    @State private var selectedSize: Int?
    
    // MARK: Views

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Color")) {
                    ForEach(colors, id: \.title) { data in
                        ColorPicker(selection: data.binding) {
                            HStack {
                                CellView(color: data.value, size: CellSize)
                                Text(data.title)
                            }
                        }
                    }
                }
                Section(header: Text("Board")) {
                    Menu(content: changeBoardSizeMenu) {
                        HStack {
                            Button("Size: \(setting.boardSize) x \(setting.boardSize)") {}
                        }
                    }
                }
                Section(
                    header: Text("GitHub"),
                    footer: Text("This app is Open Source Software (MIT)")) {
                    Link("YusukeHosonuma/SwiftUI-LifeGame",
                         destination: URL(string: "https://github.com/YusukeHosonuma/SwiftUI-LifeGame")!)
                }
                Section {
                    HCenter {
                        Button("Reset to Default", action: tapResetToDefault)
                            .foregroundColor(.red)
                            .alert(isPresented: $isAlertPresented, content: resetAlert)
                    }
                }
            }.navigationTitle("Settings")
        }
    }

    private var colors: [(title: String, value: Color, binding: Binding<Color>)] {
        [
            ("Light mode", setting.lightModeColor, $setting.lightModeColor),
            ("Dark mode",  setting.darkModeColor,  $setting.darkModeColor),
        ]
    }
    
    @ViewBuilder
    private func changeBoardSizeMenu() -> some View {
        ForEach([13, 17, 21].withIndex(), id: \.0) { index, size in
            Button("\(size) x \(size)") {
                isPresentedChangeSizeAlert[index].toggle()
                selectedSize = size
            }
            .alert(isPresented: $isPresentedChangeSizeAlert[index], content: changeSizeAlert(size: size))
        }
    }

    private func changeSizeAlert(size: Int) -> () -> Alert {{
        Alert(
            title: Text("The board will be initialized..."),
            primaryButton: .cancel(),
            secondaryButton: .destructive(Text("Change")) {
                tapBoardSize(size)
            })
    }}
    
    private func resetAlert() -> Alert {
        Alert(
            title: Text("Do you really want to reset?"),
            primaryButton: .cancel(),
            secondaryButton: .destructive(Text("Reset"), action: tapReset))
    }
    
    // MARK: Actions
    
    private func tapResetToDefault() {
        isAlertPresented.toggle()
    }
    
    private func tapBoardSize(_ size: Int) {
        setting.boardSize = size
    }
    
    private func tapReset() {
        setting.resetToDefault()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            view(.light)
            view(.dark)
        }
    }
    
    static func view(_ colorScheme: ColorScheme) -> some View {
        SettingView()
            .environmentObject(SettingEnvironment())
            .previewLayout(.fixed(width: 370.0, height: 250.0))
            .preferredColorScheme(colorScheme)
    }
}

