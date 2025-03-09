
#if TARGET_OS_VISION
import SwiftUI
import OpenXRRuntime

@main
struct MainWrapperApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        let oxr = CreateOpenXR(onInit: {
            AppDelegate.viewController.setup()
        })
        return oxr
    }
}

#endif
