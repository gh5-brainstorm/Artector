//
//  ImagePickerService.swift
//  
//
//  Created by danny santoso on 7/12/24.
//

import UIKit
import AVFoundation
import Photos

protocol ImagePickerServiceDelegate: AnyObject {
    func imagePickerService(_: ImagePickerService, didReceiveImage image: UIImage)
}

class ImagePickerService: NSObject {
    
    static let shared = ImagePickerService()
    
    private var imagePicker: UIImagePickerController?
    
    weak var delegate: ImagePickerServiceDelegate?

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
    
    private func showPhotoLibraryAccessDeniedAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Photo Library Access Denied",
            message: "Please enable access to your photo library in the Settings app.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
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

extension ImagePickerService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        delegate?.imagePickerService(self, didReceiveImage: pickedImage)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
