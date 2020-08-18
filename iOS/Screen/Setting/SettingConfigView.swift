//
//  SettingConfigView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/25.
//

import SwiftUI
import PhotosUI

struct SettingConfigView: View {

    // MARK: Dependencies
    
    @EnvironmentObject private var setting: SettingEnvironment

    // MARK: Local Properties
    
    @State private var isPresentedAlert = false
    @State private var isPresentedPhotoPicker = false
    @State private var selectedSize: Int?
    
    // MARK: Views

    var body: some View {
        Form {
            Section(header: Text("Color")) {
                ForEach(colors, id: \.title) { data in
                    ColorPicker(selection: data.binding) {
                        HStack {
                            CellView(color: data.value, size: 20)
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
            
            Section {
                HCenter {
                    Button("Reset to Default", action: showResetAlert)
                        .foregroundColor(.red)
                        .alert(isPresented: $isPresentedAlert, content: resetAlert)
                }
            }
        }
        .navigationBarTitle("Game Config")
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
            secondaryButton: .destructive(Text("Reset"), action: setting.resetToDefault)
        )
    }
    
    // MARK: Actions

    private func showPhotoPicker() {
        isPresentedPhotoPicker.toggle()
    }
    
    private func clearBackgroundImage() {
        setting.backgroundImage = nil
    }
    
    private func showResetAlert() {
        isPresentedAlert.toggle()
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
        SettingConfigView()
            .environmentObject(SettingEnvironment())
            .previewLayout(.fixed(width: 370.0, height: 250.0))
            .preferredColorScheme(colorScheme)
    }
}

