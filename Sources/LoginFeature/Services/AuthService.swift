import Foundation

/// Protocol for authentication services
public protocol AuthService {
    /// Authenticate user with credentials
    /// - Parameter credentials: The login credentials
    /// - Returns: LoginResult if successful
    /// - Throws: LoginError if authentication fails
    func authenticate(credentials: LoginCredentials) async throws -> LoginResult
}
