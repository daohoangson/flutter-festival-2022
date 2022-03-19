import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // This key has been restricted by Bundle ID
    GMSServices.provideAPIKey("AIzaSyAahRiAB6PjMMIOrfgO6JyCuCqlLnEW0bw")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
