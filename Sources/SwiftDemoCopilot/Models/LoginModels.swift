import Foundation

/// Represents user credentials for login
public struct UserCredentials {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

/// Represents the result of a login attempt
public struct LoginResult {
    public let success: Bool
    public let message: String
    public let userToken: String?
    
    public init(success: Bool, message: String, userToken: String? = nil) {
        self.success = success
        self.message = message
        self.userToken = userToken
    }
}

/// Custom error types for login operations
public enum LoginError: LocalizedError, Equatable {
    case invalidCredentials
    case networkError
    case serverError(String)
    case invalidEmail
    case emptyPassword
    
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError:
            return "Network connection error. Please try again."
        case .serverError(let message):
            return message
        case .invalidEmail:
            return "Please enter a valid email address"
        case .emptyPassword:
            return "Password cannot be empty"
        }
    }
}
