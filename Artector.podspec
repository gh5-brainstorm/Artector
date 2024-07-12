#
#  Be sure to run `pod spec lint Artector.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "Artector"
  spec.version      = "1.0.0"
  spec.summary      = "Advanced plagiarism detection and AI-powered visual recognition."
  spec.description  = "We used advanced machine learning techniques for visual pattern recognition and developed a plagiarism detection model."
  spec.homepage     = "https://github.com/gh5-brainstorm/Artector"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { "Danny Santoso" => "danny.sntoso@gmail.com" }
  spec.platform     = :ios, "12.0"
  spec.source       = { :git => "https://github.com/gh5-brainstorm/Artector.git", :tag => spec.version.to_s }
  spec.source_files = "Sources/Artector/**/*.{swift}"
  spec.swift_versions = "5.0"
end
