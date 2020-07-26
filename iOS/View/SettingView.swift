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
    
    // MARK: Views

    var body: some View {
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
            Section {
                HStack { // TODO: `HCenter` ❗
                    Spacer()
                    Button("Reset to Default", action: tapResetToDefault)
                        .foregroundColor(.red)
                        .alert(isPresented: $isAlertPresented, content: resetAlert)
                    Spacer()
                }
            }
        }
    }
    
    private var colors: [(title: String, value: Color, binding: Binding<Color>)] {
        [
            ("Light mode", setting.lightModeColor, $setting.lightModeColor),
            ("Dark mode",  setting.darkModeColor,  $setting.darkModeColor),
        ]
    }
    
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

