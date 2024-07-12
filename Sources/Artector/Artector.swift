// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UIKit

public final class Artector {
    
    public static let shared = Artector()
    
    private init() {}

    public func showGalleryPicker(from viewController: UIViewController) {
        ImagePickerService.sharedInstance.showImagePicker(from: viewController, sourceType: .photoLibrary)
    }
    
    public func showCamera(from viewController: UIViewController) {
        ImagePickerService.sharedInstance.showImagePicker(from: viewController, sourceType: .photoLibrary)
    }
}

import UIKit

class ImagePickerService: NSObject {
    
    static let sharedInstance = ImagePickerService()
    
    private var imagePicker: UIImagePickerController?
    
    func showImagePicker(from viewController: UIViewController, sourceType: UIImagePickerController.SourceType) {
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.sourceType = sourceType
        imagePicker?.modalPresentationStyle = .overFullScreen
        imagePicker?.allowsEditing = false
        
        if let picker = imagePicker {
            viewController.present(picker, animated: true, completion: nil)
        }
    }
}

extension ImagePickerService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            // Process the pickedImage as needed
            processSimilarity(image: pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func processSimilarity(image: UIImage) {
        // Implement your logic to process similarity here
        print("Processing similarity for the selected image...")
        // Example: display the selected image
        // imageView.image = image
    }
}
