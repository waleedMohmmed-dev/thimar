import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    /// ----------------------------------------------------------------------------------
    /// REQUIRED: Replace with your Google Maps API key
    ///
    /// 1. Go to https://console.cloud.google.com
    /// 2. Enable "Maps SDK for iOS"
    /// 3. Enable billing
    /// 4. Go to Credentials → Create API Key
    /// 5. Restrict key to your app's bundle ID (com.example.thimar)
    /// 6. Paste the key below
    /// ----------------------------------------------------------------------------------
    GMSServices.provideAPIKey("AIzaSyBx10ci4eMaIGUs9BEe4wPzs2dZuclIeD0")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
