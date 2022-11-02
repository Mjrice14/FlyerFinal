//
//  ImagePicker.swift
//  Flyer3.0
//
//  Created by macOS on 10/25/22.
//
// CodeWithChris Video explained this https://www.youtube.com/watch?v=a05eLxsbCCw

import Foundation
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var isPickerShowing: Bool
    var camera: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        let imagePicker = UIImagePickerController()
        if camera {
            imagePicker.sourceType = .camera
            imagePicker.delegate = context.coordinator
            imagePicker.allowsEditing = true
        }
        else {
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = context.coordinator
            imagePicker.allowsEditing = true
        }
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parent: ImagePicker
    
    init(_ picker: ImagePicker) {
        self.parent = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            DispatchQueue.main.async {
                self.parent.selectedImage = image
            }
        }
        parent.isPickerShowing = false
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.isPickerShowing = false
    }
}
