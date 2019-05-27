### DotstudioPRO.swift
DotstudioPRO library for ios & tvos swift.

##Requirements.
<ul><li>iOS 9+</li>
<li>Xcode 9+</li>
<li>Swift 5.0</li></ul>
  
##Install using CocoaPods
Add the following line to your Podfile:

```cocoapods
pod ‘DotstudioPRO’, :git => ’https://github.com/dotstudiopro/DotstudioPRO.swift.git'
```

##Usage & Configuration
First import DotstudioPRO & Next in your AppDelegate.swift add the following:

```swift
import DotstudioPRO
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  DSPRO.initializeWith(config: [“apikey”:“<api-key>“], completion: { (bInitialized) in
       // code when initialization is done.
       self.initializePlayer()
   }) { (error) in
       // code to handle error.
   }
...
}
```

