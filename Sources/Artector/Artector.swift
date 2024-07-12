// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public protocol ArtectorDelegate: AnyObject {
    func artector(_: Artector, didReceiveImage: UIImage)
}

public final class Artector {
    
    public static let shared = Artector()
    
    public weak var delegate: ArtectorDelegate?

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
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        HttpCallService.sharedInstance.uploadImage(url: Endpoints.Posts.upload.url, imageData: data) { [weak self] (statusCode: Int, response: SuccessResponse?, error: URLError?) in
            guard let self else { return }
            self.delegate?.artector(self, didReceiveImage: image)
        }
    }
}
