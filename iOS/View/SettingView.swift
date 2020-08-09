//
//  SettingView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI
import PhotosUI

private let CellSize: CGFloat = 20

struct SettingView: View {

    // MARK: Dependencies
    
    @EnvironmentObject private var setting: SettingEnvironment

    // MARK: Local Properties
    
    @State private var isAlertPresented = false
    @State private var isPresentedPhotoPicker = false
    @State private var selectedSize: Int?
    
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
            
            Section(header: Text("Board")) {
                BoardSizeMenu(size: $setting.boardSize)
            }
            
            Section(header: Text("Background Image")) {
                HCenter {
                    if let _ = setting.backgroundImage {
                        Button("Clear", action: clearBackgroundImage)
                    } else {
                        Button("Select...", action: showPhotoPicker)
                    }
                }
                .sheet(isPresented: $isPresentedPhotoPicker) {
                    PhotoPicker(configuration: configuration,
                                isPresented: $isPresentedPhotoPicker,
                                selectedImage: $setting.backgroundImage)
                }
            }
            
            Section(
                header: Text("GitHub"),
                footer: Text("This app is Open Source Software (MIT)")) {
                Link("YusukeHosonuma / SwiftUI-LifeGame",
                     destination: URL(string: "https://github.com/YusukeHosonuma/SwiftUI-LifeGame")!)
            }
            
            Section {
                HCenter {
                    Button("Reset to Default", action: tapResetToDefault)
                        .foregroundColor(.red)
                        .alert(isPresented: $isAlertPresented, content: resetAlert)
                }
            }
        }
    }

    private var configuration: PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        return config
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

    private func showPhotoPicker() {
        isPresentedPhotoPicker.toggle()
    }
    
    private func clearBackgroundImage() {
        setting.backgroundImage = nil
    }
    
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

