import SwiftUI
import LoginFeature

/// Example app demonstrating the LoginFeature
/// 
/// To use this:
/// 1. Create a new iOS app project in Xcode
/// 2. Add the LoginFeature package as a dependency
/// 3. Replace your App file with this code
@main
struct LoginDemoApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
