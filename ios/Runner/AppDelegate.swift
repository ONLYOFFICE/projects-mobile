import UIKit
import Flutter
import flutter_downloader

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        

       FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)

      //todo: fix on account manager was added
//         FlutterDownloaderPlugin.setPluginRegistrantCallback({ registry in
//             FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "vn.hunghd.flutter_downloader")!)
//             GeneratedPluginRegistrant.register(with: registry)
//         })
        
         AccountsManager.start()
        let manager = AccountsManager()
        
        let channelName = "accountProvider"
        let rootViewController : FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: rootViewController as! FlutterBinaryMessenger)
        methodChannel.setMethodCallHandler {(call: FlutterMethodCall, result: FlutterResult) -> Void in

        if (call.method == "getAccounts") {
            let account = manager.exportAccounts()
            result(account)
        }

        if (call.method == "addAccount") {
            let args = call.arguments as! Dictionary<String, Any>
            let accountString = args["accountData"] as! String
            let account = manager.add(string: accountString)
             result(true)
        }

        if (call.method == "deleteAccount") {
            let args = call.arguments as! Dictionary<String, Any>
            let accountString = args["accountData"] as! String
            let account = manager.remove(string: accountString)
             result(true)
        }

    }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

private func registerPlugins(registry: FlutterPluginRegistry) {
   if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
      FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
   }
}
