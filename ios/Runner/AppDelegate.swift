import Flutter
import UIKit
import Reachability

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var reachability: Reachability?
  var eventSink: FlutterEventSink?


  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    setupFlutterChannel()
    setupReachability()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setupFlutterChannel(){
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let statusChannel = FlutterEventChannel(name: "com.example.networkInfo/status", binaryMessenger: controller.binaryMessenger)
    statusChannel.setStreamHandler(self)
  }

  private func setupReachability(){
    do {
      reachability = try Reachability()
      try reachability?.startNotifier()
      NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
    } catch{
      print("Unable to start notifier")
    }
  }

  @objc func reachabilityChanged(notification: Notification){
    eventSink?(statusNetwork())
  }

  private func statusNetwork() -> String {
    switch reachability?.connection {
      case .wifi:
        return "wifi"
      case .cellular:
        return "cellular"
      case .unavailable:
        return "noConnection"
      default:
        return "unknown"
    }
  }

  deinit {
    reachability?.stopNotifier()
    NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
  }

}

extension AppDelegate: FlutterStreamHandler {
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    eventSink?(statusNetwork())
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
