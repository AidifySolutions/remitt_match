import UIKit
import Flutter
#if targetEnvironment(simulator)
// simulator code
#else
import LivenessSDK
#endif
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var sdkResult : FlutterResult? = nil
    var navigationController : UINavigationController? = nil
    var controller : FlutterViewController? = nil
  
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        controller  = window?.rootViewController as! FlutterViewController
        
        let FacialLivnessChannel = FlutterMethodChannel(name: "com.fiatmatch.android/liveness",
                                                        binaryMessenger: controller!.binaryMessenger)

        
        FacialLivnessChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            // Handle battery messages.
            guard call.method == "launchSDK" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self.sdkResult = result
            #if targetEnvironment(simulator)
            #else
            self.lanchSDK()
            #endif
            
        })
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
#if targetEnvironment(simulator)
//simulator code
#else
    private func lanchSDK(){
       
        let livenessConfig = LivenessConfig(setChallengeMoveYourFaceToRight: true, setChallengeMoveYourFaceToLeft: true, setChallengeOpenYourMouth: false, setChallengeNodYourHead: true, maxNumberOfChallenges: 1, isOcrRequired: false, isFaceComparisonRequired: false, nicFrontImageInBase64: "",  nicBackImageBase64: "")
        
        self.window?.rootViewController = nil;
        let viewToPush = LaunchLivenessViewController.init(nibName: "LaunchLivenessViewController", bundle: Bundle(for: LaunchLivenessViewController.self));
        viewToPush.livenessConfig = livenessConfig
        viewToPush.livenessResponseDelegate = self
        let navigationController = UINavigationController(rootViewController: controller!)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window.rootViewController = navigationController
        navigationController.isNavigationBarHidden = true
        navigationController.present(viewToPush, animated: true)
        
        
    }
#endif
}

#if targetEnvironment(simulator)
#else
extension AppDelegate: LivenessResponseDelegate{
//#if targetEnvironment(simulator)
//#else
func onLivenessComplete(livenessResponse: LivenessResponse) {
    var responseCode = ""
    var imageBase64 = ""
    if(livenessResponse.response == Response.SUCCESS){
        responseCode = "101"
        imageBase64 = livenessResponse.faceImageData != nil ? livenessResponse.faceImageData!.base64EncodedString() : ""
    }else if(livenessResponse.response == Response.FAILED){
        responseCode = "102"
    }else if(livenessResponse.response == Response.TIMEOUT){
        responseCode = "103"
    }else if(livenessResponse.response == Response.FACE_LOST){
        responseCode = "104"
    }
    sdkResult!("\(responseCode)|||\(imageBase64)")
    navigationController?.popViewController(animated: true)


}
//#endif
}
#endif
