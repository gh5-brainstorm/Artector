// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public protocol ArtectorDelegate: AnyObject {
    func artector(_: Artector, didReceiveImage image: UIImage)
}

/// A singleton class responsible for handling image picking and similarity checking.
public final class Artector {

    /// The shared singleton instance of `Artector`.
    public static let shared = Artector()
    
    /// A weak reference to the delegate that conforms to `ArtectorDelegate`.
    public weak var delegate: ArtectorDelegate?

    /// Private initializer to ensure `Artector` is only instantiated once.
    private init() {
        ImagePickerService.shared.delegate = self
    }

    /// Presents the photo gallery picker to the user.
    ///
    /// - Parameter viewController: The view controller from which to present the gallery picker.
    public func showGalleryPicker(from viewController: UIViewController) {
        ImagePickerService.shared.checkPhotoLibraryPermission(from: viewController)
    }
    
    /// Presents the camera picker to the user.
    ///
    /// - Parameter viewController: The view controller from which to present the camera picker.
    public func showCamera(from viewController: UIViewController) {
        ImagePickerService.shared.checkCameraPermission(from: viewController)
    }
    
    /// Checks the similarity of the provided image by uploading it to the server.
    ///
    /// - Parameter image: The image to check for similarity.
    public func checkSimilarrity(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        HttpCallService.sharedInstance.uploadImage(url: Endpoints.Posts.upload.url, imageData: data) { [weak self] (statusCode: Int, response: SuccessResponse?, error: URLError?) in
            guard let self = self else { return }
            self.delegate?.artector(self, didReceiveImage: image)
        }
    }
}

extension Artector: ImagePickerServiceDelegate {
    
    /// Called when the image picker service receives an image.
    ///
    /// - Parameters:
    ///   - service: The image picker service instance.
    ///   - image: The image that was received.
    func imagePickerService(_: ImagePickerService, didReceiveImage image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        HttpCallService.sharedInstance.uploadImage(url: Endpoints.Posts.upload.url, imageData: data) { [weak self] (statusCode: Int, response: SuccessResponse?, error: URLError?) in
            guard let self = self else { return }
            self.delegate?.artector(self, didReceiveImage: image)
        }
    }
}
