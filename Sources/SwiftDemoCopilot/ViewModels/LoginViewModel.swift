import Foundation
#if canImport(Combine)
import Combine
#endif

/// ViewModel for the Login screen following MVVM pattern
@MainActor
public class LoginViewModel {
    
    // MARK: - Published Properties
    
    #if canImport(Combine)
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var isLoggedIn: Bool = false
    @Published public var userToken: String?
    #else
    public var email: String = ""
    public var password: String = ""
    public var isLoading: Bool = false
    public var errorMessage: String?
    public var isLoggedIn: Bool = false
    public var userToken: String?
    #endif
    
    // MARK: - Private Properties
    
    private let loginService: LoginServiceProtocol
    
    // MARK: - Initialization
    
    public init(loginService: LoginServiceProtocol = LoginService()) {
        self.loginService = loginService
    }
    
    // MARK: - Public Methods
    
    /// Performs login using async/await
    public func login() async {
        // Clear previous errors
        errorMessage = nil
        
        // Validate input before making the request
        guard !email.isEmpty else {
            errorMessage = "Email cannot be empty"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty"
            return
        }
        
        // Set loading state
        isLoading = true
        
        do {
            // Create credentials
            let credentials = UserCredentials(email: email, password: password)
            
            // Perform login using async/await
            let result = try await loginService.login(credentials: credentials)
            
            // Update state based on result
            if result.success {
                isLoggedIn = true
                userToken = result.userToken
                errorMessage = nil
            } else {
                errorMessage = result.message
            }
        } catch let error as LoginError {
            // Handle known login errors
            errorMessage = error.localizedDescription
        } catch {
            // Handle unexpected errors
            errorMessage = "An unexpected error occurred. Please try again."
        }
        
        // Clear loading state
        isLoading = false
    }
    
    /// Resets the login state
    public func reset() {
        email = ""
        password = ""
        errorMessage = nil
        isLoading = false
        isLoggedIn = false
        userToken = nil
    }
    
    /// Clears error message
    public func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Computed Properties
    
    /// Determines if the login button should be enabled
    public var isLoginButtonEnabled: Bool {
        !email.isEmpty && !password.isEmpty && !isLoading
    }
}

// MARK: - ObservableObject Conformance

#if canImport(Combine)
extension LoginViewModel: ObservableObject {
}
#endif
