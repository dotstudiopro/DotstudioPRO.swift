<h3>DotstudioPRO.swift</h3>
<p>DotstudioPRO library for ios & tvos swift.</p>

<h3>Requirements.</h3>
<ul><li>iOS 9+</li>
<li>Xcode 9+</li>
<li>Swift 5.0</li></ul>
  
<h3>Install using CocoaPods</h3>
<p>Add the following line to your Podfile:</p>

<p>pod ‘DotstudioPRO’, :git => ’https://github.com/dotstudiopro/DotstudioPRO.swift.git'</p>

<h3>Usage & Configuration</h3>
<p>First import DotstudioPRO</p>

<p>import DotstudioPRO</p>
Next in your AppDelegate.swift add the following:

<p>
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  DSPRO.initializeWith(config: [“apikey”:“<api-key>“], completion: { (bInitialized) in
           // code when initialization is done.
           self.initializePlayer()
       }) { (error) in
           // code to handle error.
       }
...
}
</p>

