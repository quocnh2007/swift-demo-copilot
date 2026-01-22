import Foundation

/// Protocol for login service operations
public protocol LoginServiceProtocol {
    func login(credentials: UserCredentials) async throws -> LoginResult
}

/// Service responsible for handling login network requests
public class LoginService: LoginServiceProtocol {
    
    public init() {}
    
    /// Performs login with the provided credentials using async/await
    /// - Parameter credentials: User credentials (email and password)
    /// - Returns: LoginResult containing success status and optional token
    /// - Throws: LoginError if login fails
    public func login(credentials: UserCredentials) async throws -> LoginResult {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Simulate API call - In a real app, this would make an actual network request
        // For demo purposes, we'll accept any credentials that look valid
        
        // Validate email format
        guard isValidEmail(credentials.email) else {
            throw LoginError.invalidEmail
        }
        
        // Check password is not empty
        guard !credentials.password.isEmpty else {
            throw LoginError.emptyPassword
        }
        
        // Demo logic: Accept specific credentials for testing
        if credentials.email == "test@example.com" && credentials.password == "password123" {
            return LoginResult(
                success: true,
                message: "Login successful",
                userToken: "demo-token-\(UUID().uuidString)"
            )
        } else if credentials.email == "error@example.com" {
            // Simulate a server error
            throw LoginError.serverError("Internal server error")
        } else {
            // Invalid credentials
            throw LoginError.invalidCredentials
        }
    }
    
    /// Validates email format using regex
    /// - Parameter email: Email string to validate
    /// - Returns: True if email format is valid
    private func isValidEmail(_ email: String) -> Bool {
        let emailPattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"#
        if let regex = try? NSRegularExpression(pattern: emailPattern, options: []) {
            let range = NSRange(location: 0, length: email.utf16.count)
            return regex.firstMatch(in: email, options: [], range: range) != nil
        }
        return false
    }
}
