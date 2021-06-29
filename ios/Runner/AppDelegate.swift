import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
 //   var controller : FlutterViewController?
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

        let flutterChannel = FlutterMethodChannel(name: "test_activity", binaryMessenger: controller.binaryMessenger)
        flutterChannel.setMethodCallHandler { (flutterMethodCall, flutterResult) in
            if flutterMethodCall.method == "startNewActivity"
            {
                UIView.animate(withDuration: 0.5, animations:
                                {
                    self.window?.rootViewController = nil

    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyBoard.instantiateViewController(withIdentifier: "SwViewController") as! SwViewController
    let navigationController = UINavigationController(rootViewController: controller)
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.makeKeyAndVisible()
    self.window.rootViewController = navigationController
   navigationController.pushViewController(vc, animated: true)
    //self.parentController?.navigationController?.pushViewController(vc, animated: true)

                })
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
}



//import UIKit
//import Flutter
//
//@UIApplicationMain
//@objc class AppDelegate: FlutterAppDelegate {
//  override func application(
//    _ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//  ) -> Bool {
//    GeneratedPluginRegistrant.register(with: self)
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//  }
//}
