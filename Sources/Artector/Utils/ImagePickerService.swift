//
//  ImagePickerService.swift
//  
//
//  Created by danny santoso on 7/12/24.
//

import UIKit
import AVFoundation
import Photos

/// Protocol that defines delegate methods for receiving an image and handling picker closure events.
protocol ImagePickerServiceDelegate: AnyObject {
    /// Called when the image picker service receives an image.
    ///
    /// - Parameters:
    ///   - service: The image picker service instance.
    ///   - image: The received image.
    func imagePickerService(_: ImagePickerService, didReceiveImage image: UIImage)
    
    /// Called when the image picker service closes the picker.
    ///
    /// - Parameters:
    ///   - service: The image picker service instance.
    ///   - didClosePicker: A boolean indicating if the picker was closed.
    func imagePickerService(_: ImagePickerService, didClosePicker: Bool)
}

/// A service class responsible for handling image picking from the photo library or camera.
class ImagePickerService: NSObject {
    
    /// The shared singleton instance of `ImagePickerService`.
    static let shared = ImagePickerService()
    
    /// The image picker controller.
    private var imagePicker: UIImagePickerController?
    
    /// A weak reference to the delegate that conforms to `ImagePickerServiceDelegate`.
    weak var delegate: ImagePickerServiceDelegate?

    /// Checks the photo library permission and presents the image picker if authorized.
    ///
    /// - Parameter viewController: The view controller from which to present the gallery picker.
    func checkPhotoLibraryPermission(from viewController: UIViewController) {
        let photosAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photosAuthorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else { return }
                DispatchQueue.main.async {
                    self.showImagePicker(from: viewController, sourceType: .photoLibrary)
                }
            }
        case .restricted, .denied:
            // Handle restricted or denied status
            DispatchQueue.main.async {
                self.showPhotoLibraryAccessDeniedAlert(from: viewController)
            }
        case .authorized, .limited:
            // Directly show the image picker if already authorized or in limited access mode
            DispatchQueue.main.async {
                self.showImagePicker(from: viewController, sourceType: .photoLibrary)
            }
        @unknown default:
            fatalError("Unknown photo library authorization status")
        }
    }
    
    /// Checks the camera permission and presents the image picker if authorized.
    ///
    /// - Parameter viewController: The view controller from which to present the camera picker.
    func checkCameraPermission(from viewController: UIViewController) {
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
                    self.showImagePicker(from: viewController, sourceType: .camera)
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
                self.showImagePicker(from: viewController, sourceType: .camera)
            }
        @unknown default:
            fatalError("Unknown camera authorization status")
        }
    }
    
    /// Presents the image picker with the specified source type.
    ///
    /// - Parameters:
    ///   - viewController: The view controller from which to present the image picker.
    ///   - sourceType: The source type for the image picker (e.g., photo library, camera).
    private func showImagePicker(from viewController: UIViewController, sourceType: UIImagePickerController.SourceType) {
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.sourceType = sourceType
        imagePicker?.modalPresentationStyle = .overFullScreen
        imagePicker?.allowsEditing = false
        
        if let picker = imagePicker {
            viewController.present(picker, animated: true, completion: nil)
        }
    }
    
    /// Shows an alert indicating that access to the photo library is denied.
    ///
    /// - Parameter viewController: The view controller from which to present the alert.
    private func showPhotoLibraryAccessDeniedAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Photo Library Access Denied",
            message: "Please enable access to your photo library in the Settings app.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
    
    /// Shows an alert indicating that access to the camera is denied.
    ///
    /// - Parameter viewController: The view controller from which to present the alert.
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

extension ImagePickerService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// Called when the user finishes picking media.
    ///
    /// - Parameters:
    ///   - picker: The image picker controller.
    ///   - info: A dictionary containing the media information.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        picker.dismiss(animated: true, completion: {
            self.delegate?.imagePickerService(self, didReceiveImage: pickedImage)
        })
    }

    /// Called when the user cancels the image picker.
    ///
    /// - Parameter picker: The image picker controller.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {
            self.delegate?.imagePickerService(self, didClosePicker: true)
        })
    }
}
