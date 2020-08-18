def sharedPod
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
end

target 'LifeGameApp (iOS)' do
  platform :ios, '14.0'
  use_frameworks!

  sharedPod
end

target 'LifeGameWidgetExtension' do
  platform :ios, '14.0'
  use_frameworks!

  sharedPod
end

target 'LifeGameApp (macOS)' do
  platform :osx, '11'
  use_frameworks!

  sharedPod
end
