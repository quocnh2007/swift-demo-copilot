import Foundation
import SwiftUI

/// ViewModel for the Splash screen
/// Handles the 3-second timer and navigation logic
@MainActor
public final class SplashViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published public var shouldShowLogin: Bool = false
    
    // MARK: - Private Properties
    
    private static let splashDurationNanoseconds: UInt64 = 3_000_000_000 // 3 seconds
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public Methods
    
    /// Start the splash screen timer
    /// After 3 seconds, sets shouldShowLogin to true
    public func startTimer() async {
        do {
            try await Task.sleep(nanoseconds: Self.splashDurationNanoseconds)
            self.shouldShowLogin = true
        }
        catch {
            // Task was cancelled or sleep was interrupted
            // Don't navigate to login in this case
        }
    }
}
