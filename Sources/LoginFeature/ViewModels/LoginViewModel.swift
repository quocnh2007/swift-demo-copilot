import Foundation
import SwiftUI

/// ViewModel for the Login screen
/// Handles all business logic and state management for authentication
@MainActor
public final class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published public var username: String = ""
    @Published public var password: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var isLoggedIn: Bool = false
    
    // MARK: - Private Properties
    
    private let authService: AuthService
    
    // MARK: - Initialization
    
    public init(authService: AuthService = MockAuthService()) {
        self.authService = authService
    }
    
    // MARK: - Public Methods
    
    /// Attempt to log in with the current username and password
    public func login() async {
        // Clear previous error
        self.errorMessage = nil
        
        // Validate input fields
        if self.username.isEmpty || self.password.isEmpty {
            self.errorMessage = LoginError.emptyFields.errorDescription
            return
        }
        
        // Start loading
        self.isLoading = true
        
        do {
            let credentials = LoginCredentials(
                username: self.username,
                password: self.password
            )
            
            let result = try await self.authService.authenticate(credentials: credentials)
            
            // Update state on success
            self.isLoggedIn = true
            self.errorMessage = nil
            
            // In a real app, you would store the token securely (e.g., Keychain)
            print("Login successful! Token: \(result.token)")
        }
        catch let error as LoginError {
            self.errorMessage = error.errorDescription
        }
        catch {
            self.errorMessage = LoginError.unknownError(error.localizedDescription).errorDescription
        }
        
        // Stop loading
        self.isLoading = false
    }
    
    /// Clear all form fields and reset state
    public func reset() {
        self.username = ""
        self.password = ""
        self.errorMessage = nil
        self.isLoading = false
        self.isLoggedIn = false
    }
}
