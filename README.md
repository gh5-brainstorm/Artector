# Artector

**Artector** is an advanced iOS framework for plagiarism detection and AI-powered visual recognition. It leverages machine learning techniques to help designers safeguard their intellectual property rights by checking for similarities in images.

## Features

- **Plagiarism Detection**: Identify protected works and avoid copyright issues.
- **Visual Pattern Recognition**: Analyze images to detect similarities.
- **Easy Integration**: Use as a library for iOS apps or integrate as a framework in your projects.

## Installation

### CocoaPods

To integrate **Artector** into your project using CocoaPods, add the following line to your `Podfile`:

```ruby
pod 'Artector', '~> 1.0.0'
```

Then run:
```ruby
pod install
```
### Swift Package Manager (SPM)
To add Artector using SPM, include it in your Package.swift dependencies:
```swift
dependencies: [
    .package(url: "https://github.com/gh5-brainstorm/Artector.git", from: "1.0.0")
]
```
## Usage
### Importing Artector
Before using any functionality, make sure to import the framework:
```swift
import Artector
```
### Functions for Plagiarism Detection
You can access the following functions to facilitate plagiarism detection:

1. Show Gallery Picker
Presents the photo gallery picker to the user.
```swift
Artector.shared.showGalleryPicker(from: viewController)
```
2. Show Camera
Presents the camera picker to the user.
```swift
Artector.shared.showCamera(from: viewController)
```
3. Check Similarity
Checks the similarity of the provided image by uploading it to the server.
```swift
Artector.shared.checkSimilarity(image: yourUIImage)
```
## Example Implementation
Here’s an example of how to use these functions in a view controller:
```swift
import UIKit
import Artector

class YourViewController: UIViewController {

    func openGallery() {
        Artector.shared.showGalleryPicker(from: self)
    }

    func openCamera() {
        Artector.shared.showCamera(from: self)
    }

    func uploadImage(_ image: UIImage) {
        Artector.shared.checkSimilarity(image: image)
    }
}
```
## Requirements
- iOS 12.0 or later
- Swift 5.0 or later
## License
This project is licensed under the MIT License. See the [LICENSE](https://chatgpt.com/c/LICENSE) file for more details.

## Contributing
Contributions are welcome! Please open issues or submit pull requests for any improvements or features you'd like to add.

## Contact
For any inquiries, please contact:

Danny Santoso: danny.sntoso@gmail.com
## Acknowledgements
This framework supports the Sustainable Development Goals (SDGs) by enhancing economic growth and protecting intellectual property rights in the digital age.
