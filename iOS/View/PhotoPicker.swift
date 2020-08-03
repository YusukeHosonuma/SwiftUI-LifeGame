//
//  PhotoPicker.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/03.
//

import PhotosUI
import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    let configuration: PHPickerConfiguration
    
    @Binding var isPresented: Bool
    
    // Note:
    // Currently not supported to convert `Image` to `UIImage` maybe...
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> some PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Do nothing
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    internal final class Coordinator: PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isPresented = false
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let image = image as? UIImage else {
                        print("error: image is not UIImage")
                        return
                    }
                    
                    DispatchQueue.main.sync {
                        self.parent.selectedImage = image
                    }
                }
            }
        }
    }
}
