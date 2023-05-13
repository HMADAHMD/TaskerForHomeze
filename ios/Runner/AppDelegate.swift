import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBOwNtjUmHZOHLGwF5ZUQrnOe7t0pmXaMw")
    GeneratedPluginRegistrant.register(with: self)

            let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let restartChannel = FlutterMethodChannel(name: "com.example.myapp/restart", binaryMessenger: controller.binaryMessenger)
        restartChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          if (call.method == "restart") {
            exit(0)
          } else {
            result(FlutterMethodNotImplemented)
          }
        })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}