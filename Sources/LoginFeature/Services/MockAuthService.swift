import Foundation

/// Mock authentication service for testing and demonstration
public final class MockAuthService: AuthService {
    private let shouldSucceed: Bool
    private let delay: TimeInterval
    
    public init(shouldSucceed: Bool = true, delay: TimeInterval = 1.0) {
        self.shouldSucceed = shouldSucceed
        self.delay = delay
    }
    
    public func authenticate(credentials: LoginCredentials) async throws -> LoginResult {
        // Simulate network delay
        try await Task.sleep(nanoseconds: UInt64(self.delay * 1_000_000_000))
        
        // Validate credentials are not empty
        if credentials.username.isEmpty || credentials.password.isEmpty {
            throw LoginError.emptyFields
        }
        
        // Simulate authentication
        if self.shouldSucceed {
            // Mock successful authentication (demo credentials: username="demo", password="password")
            if credentials.username == "demo" && credentials.password == "password" {
                return LoginResult(
                    userId: "12345",
                    token: "mock-jwt-token-\(UUID().uuidString)",
                    username: credentials.username
                )
            }
            else {
                throw LoginError.invalidCredentials
            }
        }
        else {
            throw LoginError.networkError
        }
    }
}
