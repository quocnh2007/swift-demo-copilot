import Foundation

/// Errors that can occur during login
public enum LoginError: LocalizedError {
    case invalidCredentials
    case networkError
    case emptyFields
    case unknownError(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid username or password. Please try again."
        case .networkError:
            return "Network connection failed. Please check your internet connection."
        case .emptyFields:
            return "Please enter both username and password."
        case .unknownError(let message):
            return "An error occurred: \(message)"
        }
    }
}
