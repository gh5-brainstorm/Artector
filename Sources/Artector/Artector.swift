// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UIKit
import AVFoundation
import Photos

public final class Artector {
    
    public static let shared = Artector()
    
    private init() {}

    public func showGalleryPicker(from viewController: UIViewController) {
        let photosAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photosAuthorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else { return }
                DispatchQueue.main.async {
                    ImagePickerService.sharedInstance.showImagePicker(from: viewController, sourceType: .photoLibrary)
                }
            }
        case .restricted, .denied:
            // Handle restricted or denied status
            // Optionally, show an alert to the user to inform them about the need for photo library access
            let alert = UIAlertController(
                title: "Photo Library Access Denied",
                message: "Please enable access to your photo library in the Settings app.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true)
            
        case .authorized, .limited:
            // Directly show the image picker if already authorized or in limited access mode
            DispatchQueue.main.async {
                ImagePickerService.sharedInstance.showImagePicker(from: viewController, sourceType: .photoLibrary)
            }

        @unknown default:
            fatalError("Unknown photo library authorization status")
        }
    }
    
    public func showCamera(from viewController: UIViewController) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else {
                    DispatchQueue.main.async {
                        self.showCameraAccessDeniedAlert(from: viewController)
                    }
                    return
                }
                DispatchQueue.main.async {
                    ImagePickerService.sharedInstance.showImagePicker(from: viewController, sourceType: .camera)
                }
            }
            
        case .restricted, .denied:
            // Handle restricted or denied status
            DispatchQueue.main.async {
                self.showCameraAccessDeniedAlert(from: viewController)
            }
            
        case .authorized:
            // Directly show the camera if already authorized
            DispatchQueue.main.async {
                ImagePickerService.sharedInstance.showImagePicker(from: viewController, sourceType: .camera)
            }
            
        @unknown default:
            // Handle any future cases
            fatalError("Unknown camera authorization status")
        }
    }

    private func showCameraAccessDeniedAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Camera Access Denied",
            message: "Please enable access to your camera in the Settings app.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
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
