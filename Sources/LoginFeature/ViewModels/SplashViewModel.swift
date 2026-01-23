import Foundation
import SwiftUI

/// ViewModel for the Splash screen
/// Handles the 3-second timer and navigation logic
@MainActor
public final class SplashViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published public var shouldShowLogin: Bool = false
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public Methods
    
    /// Start the splash screen timer
    /// After 3 seconds, sets shouldShowLogin to true
    public func startTimer() {
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
            self.shouldShowLogin = true
        }
    }
}
