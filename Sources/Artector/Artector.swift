// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public final class Artector {
    
    public static let shared = Artector()
    
    private init() {}

    public func showGalleryPicker(from viewController: UIViewController) {
        ImagePickerService.shared.checkPhotoLibraryPermission(from: viewController)
    }
    
    public func showCamera(from viewController: UIViewController) {
        ImagePickerService.shared.checkCameraPermission(from: viewController)
    }
}
