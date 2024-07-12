// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

protocol ArtectorDelegate: AnyObject {
    func artector(_: Artector, didReceiveImage: UIImage)
}

public final class Artector {
    
    public static let shared = Artector()
    
    private init() {
        ImagePickerService.shared.delegate = self
    }

    public func showGalleryPicker(from viewController: UIViewController) {
        ImagePickerService.shared.checkPhotoLibraryPermission(from: viewController)
    }
    
    public func showCamera(from viewController: UIViewController) {
        ImagePickerService.shared.checkCameraPermission(from: viewController)
    }
}

extension Artector: ImagePickerServiceDelegate {
    func imagePickerService(_: ImagePickerService, didReceiveImage image: UIImage) {
        guard let data = image.pngData() else { return }
        HttpCallService.sharedInstance.uploadImage(url: "https://7f0e-111-67-81-27.ngrok-free.app/upload", imageData: data) { (statusCode: Int, response: SuccessResponse?, error: URLError?) in
            print("LOG DATA >> \(response)")
        }
    }
}
