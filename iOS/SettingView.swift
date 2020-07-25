//
//  SettingView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI

private let CellSize: CGFloat = 20

struct SettingView: View {
    @State private var isAlertPresented = false
    @EnvironmentObject private var setting: SettingEnvironment
    
    // MARK: Views
    
    var body: some View {
        Form {
            Section(header: Text("Color")) {
                ColorPicker(selection: $setting.lightModeColor) {
                    HStack {
                        CellView(color: setting.lightModeColor, size: CellSize)
                        Text("Light mode")
                    }
                }
                ColorPicker(selection: $setting.darkModeColor) {
                    HStack {
                        CellView(color: setting.darkModeColor, size: CellSize)
                        Text("Dark mode")
                    }
                }
            }
            Section {
                HStack {
                    Spacer()
                    Button("Reset to Default", action: tapResetToDefault)
                        .foregroundColor(.red)
                        .alert(isPresented: $isAlertPresented, content: resetAlert)
                    Spacer()
                }
            }
        }
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
            SettingView()
                .environmentObject(SettingEnvironment())
                .previewLayout(.fixed(width: 370.0, height: 250.0))
                .preferredColorScheme(.light)
            SettingView()
                .environmentObject(SettingEnvironment())
                .previewLayout(.fixed(width: 370.0, height: 250.0))
                .preferredColorScheme(.dark)
        }
    }
}
