// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

/// Protocol that defines delegate methods for receiving image and handling picker closure events.
public protocol ArtectorDelegate: AnyObject {
    /// Called when an image is received.
    ///
    /// - Parameters:
    ///   - artector: The `Artector` instance.
    ///   - image: The  image.
    ///   - similarity: The similarity image.
    func artector(_: Artector, didReceiveImage image: UIImage, didReceiveSimilarity similarity: [SimilarityResponse])
    
    /// Called when the image picker is closed.
    ///
    /// - Parameters:
    ///   - artector: The `Artector` instance.
    ///   - didClosePicker: A boolean indicating if the picker was closed.
    func artector(_: Artector, didClosePicker: Bool)
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
        HttpCallService.sharedInstance.uploadImage(url: Endpoints.Posts.upload.url, imageData: data) { [weak self] (statusCode: Int, response: [SimilarityResponse]?, error: URLError?) in
            guard let self = self else { return }
            if let response {
                self.delegate?.artector(self, didReceiveImage: image, didReceiveSimilarity: response)
            } else {
                self.delegate?.artector(self, didClosePicker: true)
            }
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
        HttpCallService.sharedInstance.uploadImage(url: Endpoints.Posts.upload.url, imageData: data) { [weak self] (statusCode: Int, response: [SimilarityResponse]?, error: URLError?) in
            guard let self = self else { return }
            if let response {
                self.delegate?.artector(self, didReceiveImage: image, didReceiveSimilarity: response)
            } else {
                self.delegate?.artector(self, didClosePicker: true)
            }
        }
    }
    
    /// Called when the image picker service closes the picker.
    ///
    /// - Parameter service: The image picker service instance.
    /// - Parameter didClosePicker: A boolean indicating if the picker was closed.
    func imagePickerService(_: ImagePickerService, didClosePicker: Bool) {
        self.delegate?.artector(self, didClosePicker: didClosePicker)
    }
}
