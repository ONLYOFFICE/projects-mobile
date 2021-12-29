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
        
//         AccountsManager.start()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

private func registerPlugins(registry: FlutterPluginRegistry) {
   if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
      FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
   }
}
