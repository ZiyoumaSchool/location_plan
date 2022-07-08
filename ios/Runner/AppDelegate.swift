import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    lazy var flutterEngine = FlutterEngine(name: "MyApp")
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      flutterEngine.run()
      
    GMSServices.provideAPIKey("AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU")
      
      GeneratedPluginRegistrant.register(with: self.flutterEngine)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
