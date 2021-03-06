### DotstudioPRO.swift
DotstudioPRO library for ios & tvos swift.

## Requirements.
<ul><li>iOS 9+</li>
<li>Xcode 10.2.1</li>
<li>Swift 5.0</li></ul>
  
## Install using CocoaPods
Add the following line to your Podfile:

```cocoapods
pod ‘DotstudioPRO’, :git => ’https://github.com/dotstudiopro/DotstudioPRO.swift.git'
```

# Installation Notes
<ul>
  <li>If developing using Xcode 10 and targeting iOS devices running iOS 12 or higher, the "Access WiFi Information" capability is required in order to discover and connect to Cast devices.</li>
  <li>You need to add Microphone usage permission.</li>
 </ul>

## Usage & Configuration
First import DotstudioPRO & Next in your AppDelegate.swift add the following:

```swift
import DotstudioPRO
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  DSPRO.initializeWith(config: [“apikey”:“<api-key>“], completion: { (bInitialized) in
       // code when initialization is done.
       
   }) { (error) in
       // code to handle error.
   }
...
}
```
# Configuration Parameters
<ul>
  <li>apikey : Pass Company Api Key</li>
</ul>


# Create iOS Player
```swift
if let dspPlayerViewController = DSPPlayerViewController.getViewController() {
    dspPlayerViewController.view.frame = self.playerContainerView.bounds
    self.playerContainerView.addSubview(dspPlayerViewController.view)
    let dspVideo = DSPVideo()
    dspVideo.strId = "<video-id>"
    dspPlayerViewController.setCurrentVideo(curVideo: dspVideo)
}
```

# Create tvOS Player
```swift
if let dspPlayerViewController = DSPPlayerViewController.getViewController() {
    let dspVideo = DSPVideo()
    dspVideo.strId = "<video-id>"
    dspPlayerViewController.setCurrentVideo(curVideo: dspVideo)
    self.present(dspPlayerViewController, animated: true, completion: nil)
}
```

